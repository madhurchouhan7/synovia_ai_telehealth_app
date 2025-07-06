// functions/index.js
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { GoogleGenerativeAI } = require('@google/generative-ai');
const util = require('util'); // Import Node.js util module for deep inspection

admin.initializeApp();
const db = admin.firestore();

const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);

exports.getPersonalizedMedicalAdvice = functions.https.onCall(async (data, context) => {
    // --- DEBUGGING SECTION (keep for now, but you can remove later) ---
    console.log('Function: Raw incoming data object (util.inspect):', util.inspect(data, { depth: null }));
    console.log('Function: Type of incoming data:', typeof data);
    console.log('Function: Is data null or undefined?', data === null || typeof data === 'undefined');
    if (data && typeof data === 'object') {
        console.log('Function: Keys in incoming data:', Object.keys(data));
        // Log the nested data object too
        console.log('Function: Value of data.data (direct access):', data.data);
        console.log('Function: Value of data.data.symptoms (direct access):', data.data ? data.data.symptoms : 'data.data is null/undefined');
    } else {
        console.log('Function: Incoming data is not an object or is null/undefined.');
    }
    // --- END DEBUGGING SECTION ---

    // Temporarily keep the userId bypass for now
    const userId = context.auth ? context.auth.uid : 'DEBUG_ANONYMOUS_USER';
    console.log('Function: Using userId:', userId);

    // --- CRITICAL FIX: Access symptoms from data.data.symptoms ---
    let userSymptoms;
    if (data && typeof data === 'object' && data.data && typeof data.data === 'object' && typeof data.data.symptoms === 'string') {
        userSymptoms = data.data.symptoms.trim();
        console.log('Function: Extracted symptoms from data.data.symptoms:', userSymptoms);
    } else {
        console.warn('Function: Data object does not contain expected nested "data.symptoms" string.');
        userSymptoms = 'unknown or unreadable symptoms'; // Fallback
    }

    if (!userSymptoms || userSymptoms === 'unknown or unreadable symptoms') {
        console.warn('Function: Final userSymptoms determined to be invalid or missing.');
        throw new functions.https.HttpsError('invalid-argument', 'Missing or invalid symptoms provided.');
    }
    console.log('Function: Final userSymptoms determined for prompt:', userSymptoms);


    let userData = {};
    try {
        if (userId !== 'DEBUG_ANONYMOUS_USER') {
            const userDoc = await db.collection('users').doc(userId).get();
            if (userDoc.exists) {
                userData = userDoc.data();
                console.log('Function: User data fetched successfully for UID:', userId);
            } else {
                console.warn(`Function: User data not found for userId: ${userId}`);
            }
        } else {
            console.warn('Function: Using dummy user data for unauthenticated call.');
        }
    } catch (error) {
        console.error('Function: Error fetching user data:', error);
        throw new functions.https.HttpsError('internal', 'Failed to retrieve user data.');
    }

    // ... rest of your prompt construction and Gemini API call ...
    let fullPrompt = `You are a highly empathetic and knowledgeable medical AI assistant. Your primary goal is to classify user-provided symptoms into 'low', 'mild', or 'risky' categories and provide appropriate, personalized advice. Always prioritize patient safety.

    User's Personal Health Data:
    Age: ${userData.age || 'not provided'}
    Gender: ${userData.gender || 'not provided'}
    Known Medical Conditions: ${userData.medicalConditions && userData.medicalConditions.length > 0 ? userData.medicalConditions.join(', ') : 'none'}
    Allergies: ${userData.allergies && userData.allergies.length > 0 ? userData.allergies.join(', ') : 'none'}
    Current Medications: ${userData.medications && userData.medications.length > 0 ? userData.medications.join(', ') : 'none'}
    Lifestyle Notes: ${userData.lifestyle || 'none'}
    // Add more relevant fields from your Firestore user data

    User's Symptoms: "${userSymptoms}"

    Based on the user's personal health data and the symptoms provided, please:
    1. Classify the severity of these symptoms into 'low', 'mild', or 'risky'. Provide the classification clearly.
    2. Explain your reasoning briefly.
    3. Provide personalized advice based on the severity.
    4. Do NOT give definitive diagnoses. Always advise consulting a medical professional.
    5. Keep the response concise but informative.
    `;

    const model = genAI.getGenerativeModel({ model: 'gemini-2.0-flash' });
    try {
        const result = await model.generateContent(fullPrompt);
        const response = result.response;
        const text = response.text();

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

        if (userId !== 'DEBUG_ANONYMOUS_USER') {
            await db.collection('users').doc(userId).update({
                activeSymptomSeverity: classification,
                lastSymptoms: userSymptoms,
                lastAiResponse: text,
                updatedAt: admin.firestore.FieldValue.serverTimestamp()
            }, { merge: true });
        } else {
            console.warn('Function: Skipped Firestore update for DEBUG_ANONYMOUS_USER.');
        }

        return {
            severity: classification,
            advice: text
        };

    } catch (error) {
        console.error('Function: Error calling Gemini API:', error);
        throw new functions.https.HttpsError('internal', 'Failed to get personalized advice from AI.');
    }
});