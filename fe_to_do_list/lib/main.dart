import 'package:contact_dio/view/screen/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const OnboardingPage(),
    );
  }
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentPage = 0;
  PageController pageController = PageController();

  List<Map<String, String>> onboardingData = [
    {
      'image': 'images/aryka.jpg',
      'name': 'Aryka Anisa P',
      'npm': '1214035',
    },
    {
      'image': 'images/dani.jpg',
      'name': 'Dani Ferdinan',
      'npm': '1214050',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: pageController,
                itemCount: onboardingData.length,
                itemBuilder: (context, index) => OnboardingCard(
                  image: onboardingData[index]['image']!,
                  name: onboardingData[index]['name']!,
                  npm: onboardingData[index]['npm']!,
                ),
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (index) => buildDot(index: index),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Hapus tombol "Sebelumnya" pada onboarding pertama kali
                      if (currentPage > 0)
                        TextButton(
                          onPressed: () {
                            pageController.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          },
                          child: Text(
                            'Sebelumnya',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      // Tampilkan tombol "Skip" pada onboarding kedua
                      if (currentPage == 1)
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      TextButton(
                        onPressed: () {
                          if (currentPage == onboardingData.length - 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const OnboardingDetailsPage()),
                            );
                          } else {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          }
                        },
                        child: Text(
                          currentPage == onboardingData.length - 1
                              ? 'Lanjut'
                              : 'Selanjutnya',
                          style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      width: currentPage == index ? 30 : 10,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.indigo : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingCard extends StatelessWidget {
  final String image;
  final String name;
  final String npm;

  const OnboardingCard({
    Key? key,
    required this.image,
    required this.name,
    required this.npm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '$name\nNPM: $npm',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class OnboardingDetailsPage extends StatelessWidget {
  const OnboardingDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: PageView(
                children: [
                  OnboardingDetailsCard(
                    title: 'Fitur 1',
                    description: 'Deskripsi fitur 1',
                  ),
                  // Add more cards as needed
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                              context); // Go back to the previous onboarding page
                        },
                        child: Text(
                          'Sebelumnya',
                          style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: Text(
                          'Selanjutnya',
                          style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingDetailsCard extends StatelessWidget {
  final String title;
  final String description;

  const OnboardingDetailsCard({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
