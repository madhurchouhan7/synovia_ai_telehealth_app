import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/resources/model/article.dart';
import 'package:synovia_ai_telehealth_app/features/resources/screens/article_detail_screen.dart';
import 'package:synovia_ai_telehealth_app/features/resources/widget/article_card.dart'; // Import your new detail screen

class ResourcesArticle extends StatelessWidget {
  ResourcesArticle({super.key});

  // --- Sample Data (Replace with your actual data source later) ---
  final List<Article> sampleArticles = [
    Article(
      id: '1',
      title: 'Understanding Telehealth Benefits',
      description:
          'Discover how telehealth can improve your access to healthcare and provide convenient medical consultations from home.',
      imageUrl:
          'https://sa1s3optim.patientpop.com/assets/images/provider/photos/2635379.jpg',
      content: '''
        Telehealth, also known as telemedicine, allows healthcare providers to deliver medical services remotely, often through video calls, phone calls, or secure messaging. This revolutionary approach has numerous benefits for both patients and providers.

        **Convenience and Accessibility:**
        One of the primary advantages of telehealth is its unparalleled convenience. Patients can consult with doctors from the comfort of their homes, eliminating the need for travel, taking time off work, or arranging childcare. This is particularly beneficial for individuals in rural areas with limited access to specialists, or for those with mobility issues.

        **Reduced Exposure to Illness:**
        In an era where infectious diseases are a concern, telehealth offers a safer alternative to in-person visits, reducing the risk of exposure to viruses and other pathogens in crowded waiting rooms. This is especially important for immunocompromised individuals.

        **Cost Savings:**
        Telehealth can lead to cost savings for patients by reducing transportation expenses, parking fees, and lost wages due to time off work. Some studies also suggest that telehealth can reduce healthcare costs overall by preventing unnecessary emergency room visits and hospitalizations.

        **Continuity of Care:**
        For chronic conditions or follow-up appointments, telehealth facilitates consistent and ongoing care. Patients can easily connect with their regular healthcare providers, ensuring continuity and personalized treatment plans.

        **Mental Health Support:**
        Telehealth has proven particularly effective for mental health services. Many individuals find it easier to open up and discuss sensitive topics from a private, comfortable environment. Online therapy and counseling sessions have become widely adopted and highly successful.

        **Specialist Access:**
        Telehealth bridges geographical gaps, allowing patients to access specialists who might not be available locally. This expands treatment options and ensures patients receive the best possible care, regardless of their location.

        In conclusion, telehealth is transforming healthcare delivery, making it more accessible, convenient, and efficient. As technology continues to advance, its role in modern medicine will only grow.
        ''',
    ),
    Article(
      id: '2',
      title: 'Staying Healthy in the Digital Age',
      description:
          'Learn tips and tricks for maintaining physical and mental well-being while navigating a digitally-driven world.',
      imageUrl:
          'https://i0.wp.com/mdforlives.com/blog/wp-content/uploads/2023/10/Mindfulness-in-the-Digital-Age-1024x581.jpg?resize=1024%2C581',
      content: '''
        The digital age has brought unprecedented connectivity and convenience, but it also presents new challenges for our health. Spending prolonged hours in front of screens, the constant influx of information, and the blurring lines between work and personal life can take a toll on our physical and mental well-being. Here's how to stay healthy in this digitally-driven world.

        **1. Practice Digital Detox:**
        Regularly disconnect from your devices. Designate specific times or days as screen-free zones. This allows your mind to rest, reduces digital fatigue, and encourages engagement in real-world activities.

        **2. Maintain Good Posture and Ergonomics:**
        When working on computers or using mobile devices, pay attention to your posture. Invest in an ergonomic chair, ensure your screen is at eye level, and take frequent breaks to stretch and move around. Poor posture can lead to back pain, neck strain, and headaches.

        **3. Protect Your Eyes:**
        The "20-20-20 rule" is crucial: every 20 minutes, look at something 20 feet away for at least 20 seconds. Also, ensure adequate lighting, reduce screen glare, and consider using blue light filters if you experience eye strain.

        **4. Prioritize Sleep:**
        The blue light emitted by screens can disrupt melatonin production, making it harder to fall asleep. Avoid screens for at least an hour before bedtime. Establish a consistent sleep schedule and create a relaxing bedtime routine.

        **5. Engage in Physical Activity:**
        Combat sedentary habits by incorporating regular exercise into your routine. Even short bursts of activity throughout the day can make a difference. Consider standing desks or taking walking breaks during calls.

        **6. Mindful Information Consumption:**
        The internet provides endless information, but it can also lead to anxiety and information overload. Be mindful of what you consume. Limit news intake, unfollow accounts that trigger negative emotions, and seek out positive and inspiring content.

        **7. Connect Offline:**
        While digital platforms offer connection, prioritize face-to-face interactions. Spend time with loved ones, engage in hobbies, and participate in community activities. Real-world connections are vital for mental health.

        Staying healthy in the digital age requires conscious effort and intentional habits. By balancing your digital life with your physical and mental well-being, you can harness the benefits of technology without sacrificing your health.
        ''',
    ),
    Article(
      id: '3',
      title: 'Nutrition Tips for a Busy Life',
      description:
          'Quick and easy ways to maintain a balanced diet even with a hectic schedule.',
      imageUrl:
          'https://www.bigrockhq.com/wp-content/uploads/2019/01/13-Top-Nutrition-and-Lifestyle-Tips-to-Increase-Your-Productivity-at-Work-1080x675.jpg',
      content: '''
        In today's fast-paced world, maintaining a healthy and balanced diet often feels like an impossible task. Hectic schedules, long work hours, and the constant temptation of convenience foods can make it difficult to prioritize nutrition. However, with a few simple strategies, you can fuel your body effectively even when time is scarce.

        **1. Plan Ahead with Meal Prep:**
        Dedicate a few hours each week to meal prepping. Cook large batches of grains, proteins, and vegetables that you can mix and match throughout the week. This minimizes decision fatigue during busy weekdays and ensures you have healthy options readily available.

        **2. Keep Healthy Snacks Handy:**
        Avoid unhealthy cravings by stocking up on nutritious snacks. Think fruits, nuts, seeds, yogurt, vegetable sticks with hummus, or whole-grain crackers. Keep them in your bag, car, and desk drawer.

        **3. Prioritize Protein and Fiber:**
        Include a source of protein and fiber in every meal. Protein helps you feel full and satisfied, while fiber aids digestion and stabilizes blood sugar. Examples include lean meats, fish, beans, lentils, whole grains, fruits, and vegetables.

        **4. Hydrate, Hydrate, Hydrate:**
        Often, thirst is mistaken for hunger. Keep a water bottle with you throughout the day and sip regularly. Adequate hydration is crucial for energy levels, metabolism, and overall body function.

        **5. Don't Skip Breakfast:**
        Breakfast kickstarts your metabolism and provides energy for the day. Opt for quick and nutritious options like oatmeal with berries, Greek yogurt with granola, or a whole-wheat toast with avocado and egg.

        **6. Be Mindful When Eating Out:**
        If dining out is unavoidable, make smart choices. Look for grilled or baked options, ask for sauces on the side, and don't be afraid to customize your order to include more vegetables. Control portion sizes.

        **7. Listen to Your Body:**
        Pay attention to your hunger and fullness cues. Eat when you're hungry and stop when you're satisfied, not necessarily when your plate is empty. Practice mindful eating by slowing down and savoring your food.

        Maintaining good nutrition in a busy life is about making conscious choices and developing sustainable habits. Small changes can lead to significant improvements in your energy, mood, and overall health.
        ''',
    ),
  ];
  // --- End Sample Data ---

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Fixed height for the horizontal scrollable area
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ), // Padding for the entire list
        itemCount: sampleArticles.length,
        itemBuilder: (context, index) {
          final article = sampleArticles[index];
          return ArticleCard(
            article: article,
            onTap: () {
              // Navigate to the ArticleDetailScreen when a card is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetailScreen(article: article),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
