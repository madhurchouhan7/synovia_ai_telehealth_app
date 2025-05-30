import 'package:flutter/material.dart';
import 'package:synovia_ai_telehealth_app/config/routes.dart';
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
          'https://media.npr.org/assets/img/2021/02/19/scott_kobner03_wide-fd05f3d15fbb710e3b0d1f63940134616c2987a6.jpg?s=1400&c=100&f=jpeg',
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
          'https://media.istockphoto.com/id/509179588/photo/peaceful-meditation.jpg?s=612x612&w=0&k=20&c=uCgb3OPd8JQsj2V-HmvM8J_KUoqjaQ87dc6SYwgj47Q=',
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
          'https://blackwhite.pictures/media/t/2112/fruit-ripe-dish-meal-produce-vegetable-2172.jpg',
      content: '''
        In today's fast-paced world, maintaining a healthy and balanced diet often feels like an impossible task. Hectic schedules, long work hours, and the constant temptation of convenience foods can make it difficult to prioritize nutrition. However, with a few simple strategies, you can fuel your body effectively even when time is scarce.

        **1. Plan Ahead with Meal Prep:**
        \nDedicate a few hours each week to meal prepping. Cook large batches of grains, proteins, and vegetables that you can mix and match throughout the week. This minimizes decision fatigue during busy weekdays and ensures you have healthy options readily available.

        **2. Keep Healthy Snacks Handy:**
        \nAvoid unhealthy cravings by stocking up on nutritious snacks. Think fruits, nuts, seeds, yogurt, vegetable sticks with hummus, or whole-grain crackers. Keep them in your bag, car, and desk drawer.

        **3. Prioritize Protein and Fiber:**
        \nInclude a source of protein and fiber in every meal. Protein helps you feel full and satisfied, while fiber aids digestion and stabilizes blood sugar. Examples include lean meats, fish, beans, lentils, whole grains, fruits, and vegetables.

        **4. Hydrate, Hydrate, Hydrate:**
        \nOften, thirst is mistaken for hunger. Keep a water bottle with you throughout the day and sip regularly. Adequate hydration is crucial for energy levels, metabolism, and overall body function.

        **5. Don't Skip Breakfast:**
        \nBreakfast kickstarts your metabolism and provides energy for the day. Opt for quick and nutritious options like oatmeal with berries, Greek yogurt with granola, or a whole-wheat toast with avocado and egg.

        **6. Be Mindful When Eating Out:**
        \nIf dining out is unavoidable, make smart choices. Look for grilled or baked options, ask for sauces on the side, and don't be afraid to customize your order to include more vegetables. Control portion sizes.

        **7. Listen to Your Body:**
        \nPay attention to your hunger and fullness cues. Eat when you're hungry and stop when you're satisfied, not necessarily when your plate is empty. Practice mindful eating by slowing down and savoring your food.

        \nMaintaining good nutrition in a busy life is about making conscious choices and developing sustainable habits. Small changes can lead to significant improvements in your energy, mood, and overall health.
        ''',
    ),

    Article(
      id: '4',
      title: 'Obesity and overweight',
      description:
          'Obesity is a chronic complex disease defined by excessive fat deposits that can impair health. Obesity can lead to increased risk of type 2 diabetes and heart disease, it can affect bone health and reproduction, it increases the risk of certain cancers. Obesity influences the quality of living, such as sleeping or moving.',
      imageUrl:
          'https://i0.wp.com/post.medicalnewstoday.com/wp-content/uploads/sites/3/2021/04/GettyImages-1271322243_header2-1024x575.jpg?w=1155&h=1528',
      content: '''
        In today's fast-paced world, maintaining a healthy and balanced diet often feels like an impossible task. Hectic schedules, long work hours, and the constant temptation of convenience foods can make it difficult to prioritize nutrition. However, with a few simple strategies, you can fuel your body effectively even when time is scarce.

        **Facts about overweight and obesity:**
        \nIn 2022, 2.5 billion adults aged 18 years and older were overweight, including over 890 million adults who were living with obesity. This corresponds to 43% of adults aged 18 years and over (43% of men and 44% of women) who were overweight; an increase from 1990, when 25% of adults aged 18 years and over were overweight. Prevalence of overweight varied by region, from 31% in the WHO South-East Asia Region and the African Region to 67% in the Region of the Americas.



        **2. Keep Healthy Snacks Handy:**
        \nAvoid unhealthy cravings by stocking up on nutritious snacks. Think fruits, nuts, seeds, yogurt, vegetable sticks with hummus, or whole-grain crackers. Keep them in your bag, car, and desk drawer.

        **3. Prioritize Protein and Fiber:**
        \nInclude a source of protein and fiber in every meal. Protein helps you feel full and satisfied, while fiber aids digestion and stabilizes blood sugar. Examples include lean meats, fish, beans, lentils, whole grains, fruits, and vegetables.

        **4. Hydrate, Hydrate, Hydrate:**
        \nOften, thirst is mistaken for hunger. Keep a water bottle with you throughout the day and sip regularly. Adequate hydration is crucial for energy levels, metabolism, and overall body function.

        **5. Don't Skip Breakfast:**
        \nBreakfast kickstarts your metabolism and provides energy for the day. Opt for quick and nutritious options like oatmeal with berries, Greek yogurt with granola, or a whole-wheat toast with avocado and egg.

        **6. Be Mindful When Eating Out:**
        \nIf dining out is unavoidable, make smart choices. Look for grilled or baked options, ask for sauces on the side, and don't be afraid to customize your order to include more vegetables. Control portion sizes.

        **7. Listen to Your Body:**
        \nPay attention to your hunger and fullness cues. Eat when you're hungry and stop when you're satisfied, not necessarily when your plate is empty. Practice mindful eating by slowing down and savoring your food.

        \nMaintaining good nutrition in a busy life is about making conscious choices and developing sustainable habits. Small changes can lead to significant improvements in your energy, mood, and overall health.
        ''',
    ),
  ];

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
                pageRoute(ArticleDetailScreen(article: article)),
              );
            },
          );
        },
      ),
    );
  }
}
