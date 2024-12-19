import 'package:flutter/material.dart';

class DevelopersScreen extends StatelessWidget {
  final List<Map<String, String>> developers = [
    {"name": "Enrique Marco C. Dela Vega", "image": "images/eco.jpg"},
    {"name": "Lemuel John D. Guevara", "image": "images/lemuel.jpg"},
    {"name": "Jason Lloyd T. Rodriguez", "image": "images/jason.png"},
  ];

  DevelopersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Developers"),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/header.jpg'),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: developers.length,
                itemBuilder: (context, index) {
                  final developer = developers[index];
        
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.2,
                          backgroundImage: AssetImage(developer['image']!),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          developer['name']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
