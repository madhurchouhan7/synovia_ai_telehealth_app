// functions/index.js
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { GoogleGenerativeAI } = require('@google/generative-ai');
const util = require('util');

admin.initializeApp();
const db = admin.firestore();

const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);


// exports.sendScheduledReminders = functions.pubsub.schedule('every 1 minutes').onRun(async (context) => {
//   const now = admin.firestore.Timestamp.now();
//   const soon = admin.firestore.Timestamp.fromMillis(now.toMillis() + 60 * 1000);

//   const remindersSnapshot = await admin.firestore().collection('reminders')
//     .where('time', '>=', now)
//     .where('time', '<', soon)
//     .get();

//   for (const doc of remindersSnapshot.docs) {
//     const reminder = doc.data();
//     const userDoc = await admin.firestore().collection('users').doc(reminder.userId).get();
//     const fcmToken = userDoc.data().fcmToken;
//     if (fcmToken) {
//       await admin.messaging().send({
//         token: fcmToken,
//         notification: {
//           title: reminder.title,
//           body: reminder.description,
//         },
//         data: {
//           type: reminder.type,
//           reminderId: doc.id,
//         },
//       });
//     }
//   }
//   return null;
// });

exports.getPersonalizedMedicalAdvice = functions.https.onCall(async (data, context) => {
    console.log('CF: Function started. Incoming raw data object:', data);
    console.log('CF: Auth context (from Firebase Functions):', JSON.stringify(context.auth));

    const actualPayload = data.data || {};

    let userId = context.auth ? context.auth.uid : null;

    if (!userId && actualPayload.idToken) {
        try {
            const decodedToken = await admin.auth().verifyIdToken(actualPayload.idToken);
            userId = decodedToken.uid;
            console.log('CF: Successfully verified ID token from payload. User ID:', userId);
        } catch (error) {
            console.error('CF: Failed to verify ID token from payload:', error);
            userId = null;
        }
    }

    if (userId === null) {
        userId = 'DEBUG_ANONYMOUS_USER';
        console.warn('CF: No authenticated user context or valid ID token found. Using DEBUG_ANONYMOUS_USER.');
    } else {
        console.log('CF: Determined userId:', userId);
    }

    let userSymptoms;
    if (actualPayload && typeof actualPayload === 'object' && typeof actualPayload.symptoms === 'string') {
        userSymptoms = actualPayload.symptoms.trim();
    } else {
        console.error('CF: Payload does not contain expected "symptoms" string. Actual payload:', JSON.stringify(actualPayload));
        throw new functions.https.HttpsError('invalid-argument', 'Missing or invalid symptoms provided.');
    }
    console.log('CF: Final userSymptoms determined for prompt:', userSymptoms);


    let userData = {};
    try {
        if (userId !== 'DEBUG_ANONYMOUS_USER') {
            const userDoc = await db.collection('users').doc(userId).get();
            if (userDoc.exists) {
                userData = userDoc.data();
                console.log('CF: User data fetched successfully for UID:', userId, 'Data:', JSON.stringify(userData));
            } else {
                console.warn(`CF: User data not found for userId: ${userId}`);
            }
        } else {
            console.warn('CF: Using dummy user data for unauthenticated call.');
        }
    } catch (error) {
        console.error('CF: Error fetching user data:', error);
        throw new functions.https.HttpsError('internal', 'Failed to retrieve user data.');
    }

    let fullPrompt = `You are a highly empathetic and knowledgeable medical AI assistant. Your primary goal is to classify user-provided symptoms into 'low', 'mild', or 'risky' categories and provide appropriate, personalized advice. Always prioritize patient safety.

    User's Personal Health Data:
    Age: ${userData.age || 'not provided'}
    Gender: ${userData.gender || 'not provided'}
    Known Medical Conditions: ${userData.medicalConditions && userData.medicalConditions.length > 0 ? userData.medicalConditions.join(', ') : 'none'}
    Allergies: ${userData.allergies && userData.allergies.length > 0 ? userData.allergies.join(', ') : 'none'}
    Current Medications: ${userData.medications && userData.medications.length > 0 ? userData.medications.join(', ') : 'none'}
    Lifestyle Notes: ${userData.lifestyle || 'none'}

    User's Symptoms: "${userSymptoms}"

    Based on the user's personal health data and the symptoms provided, please provide your response in the following structured format:

    **Classification:** [low/mild/risky]
    **Reasoning:** [Brief explanation for classification]
    **RecommendedSpecialist:** [Type of doctor/specialist, e.g., General Physician, Orthopedic Surgeon, Cardiologist, Dermatologist, Neurologist, Dentist, Ophthalmologist. If unsure or low severity, suggest 'General Physician'. Be specific if the symptoms strongly indicate a particular field. Provide only the primary specialist type, without additional descriptions or parentheses.]
    **Advice:** [Personalized advice based on severity. Include the phrase "I have added nearby doctors for that." at the end of your advice if a specialist is recommended.]

    Do NOT give definitive diagnoses. Always advise consulting a medical professional. Keep the response concise but informative.
    `;

    const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });
    try {
        const result = await model.generateContent(fullPrompt);
        const response = result.response;
        const text = response.text();
        console.log('CF: Raw Gemini response text:', text);

        let classification = 'unknown';
        const classificationMatch = text.match(/Classification:\s*(low|mild|risky)/i);
        if (classificationMatch && classificationMatch[1]) {
            classification = classificationMatch[1].toLowerCase();
        } else {
            if (text.toLowerCase().includes('emergency') || text.toLowerCase().includes('risky') || text.toLowerCase().includes('immediate medical attention')) {
                classification = 'risky';
            } else if (text.toLowerCase().includes('consult a doctor') || text.toLowerCase().includes('mild') || text.toLowerCase().includes('monitor')) {
                classification = 'mild';
            } else {
                classification = 'low';
            }
        }

        let recommendedSpecialist = 'General Physician';
        const specialistMatch = text.match(/RecommendedSpecialist:\s*([^\n]+)/i);
        if (specialistMatch && specialistMatch[1]) {
            recommendedSpecialist = specialistMatch[1].trim();
            // --- CRITICAL FIX: More robust cleaning for specialist name ---
            recommendedSpecialist = recommendedSpecialist
                .replace(/^\*+\s*/, '') // Remove leading asterisks (e.g., "** Dentist")
                .replace(/\s*\(.*?\)\s*$/, '') // Remove anything in parentheses (e.g., "(Optometrist may also be beneficial.")
                .replace(/\.$/, '') // Remove trailing periods
                .trim(); // Final trim

            console.log('CF: Extracted RecommendedSpecialist (cleaned):', recommendedSpecialist); // <--- UPDATED LOG
        } else {
            console.warn('CF: Could not explicitly extract RecommendedSpecialist from Gemini response. Attempting fallback.');
            if (userSymptoms.toLowerCase().includes('tooth') || userSymptoms.toLowerCase().includes('gum') || userSymptoms.toLowerCase().includes('dental')) {
                recommendedSpecialist = 'Dentist';
            } else if (userSymptoms.toLowerCase().includes('eye') || userSymptoms.toLowerCase().includes('vision')) { // Added fallback for eye symptoms
                recommendedSpecialist = 'Ophthalmologist';
            } else if (classification === 'risky' && userSymptoms.toLowerCase().includes('chest pain')) {
                recommendedSpecialist = 'Cardiologist';
            } else if (classification === 'risky' && (userSymptoms.toLowerCase().includes('broken') || userSymptoms.toLowerCase().includes('fracture') || userSymptoms.toLowerCase().includes('bone'))) {
                recommendedSpecialist = 'Orthopedic Surgeon';
            } else if (classification === 'risky' && (userSymptoms.toLowerCase().includes('headache') || userSymptoms.toLowerCase().includes('dizziness') || userSymptoms.toLowerCase().includes('numbness'))) {
                recommendedSpecialist = 'Neurologist';
            } else if (classification === 'mild' && (userSymptoms.toLowerCase().includes('rash') || userSymptoms.toLowerCase().includes('skin'))) {
                recommendedSpecialist = 'Dermatologist';
            }
            console.log('CF: Fallback RecommendedSpecialist:', recommendedSpecialist);
        }

        if (userId && userId !== 'DEBUG_ANONYMOUS_USER') {
            console.log(`CF: Attempting to update Firestore for user: ${userId} with recommendedSpecialist: ${recommendedSpecialist}`);
            try {
                // Update user document with current symptom info
                await db.collection('users').doc(userId).update({
                    activeSymptomSeverity: classification,
                    lastSymptoms: userSymptoms,
                    lastAiResponse: text,
                    recommendedSpecialist: recommendedSpecialist,
                    updatedAt: admin.firestore.FieldValue.serverTimestamp()
                }, { merge: true });

                // Save to symptoms history collection
                const symptomRecord = {
                    symptoms: userSymptoms,
                    severity: classification,
                    aiAdvice: text,
                    recommendedSpecialist: recommendedSpecialist,
                    timestamp: admin.firestore.FieldValue.serverTimestamp(),
                    isActive: true,
                    followUpNotes: null,
                    resolvedAt: null
                };

                await db.collection('users').doc(userId)
                    .collection('symptoms_history')
                    .doc(Date.now().toString())
                    .set(symptomRecord);

                console.log('CF: Firestore update and symptoms history save successful for user:', userId);
            } catch (firestoreError) {
                console.error('CF: ERROR during Firestore update for user:', userId, 'Error:', firestoreError);
            }
        } else {
            console.warn('CF: Skipped Firestore update because no valid authenticated user ID was found.');
        }

        return {
            severity: classification,
            advice: text,
            recommendedSpecialist: recommendedSpecialist
        };

    } catch (error) {
        console.error('CF: Error calling Gemini API or processing response:', error);
        throw new functions.https.HttpsError('internal', 'Failed to get personalized advice from AI.');
    }
});