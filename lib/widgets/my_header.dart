import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class MyHeader extends StatelessWidget {
  final String headerText;

  const MyHeader(this.headerText, {super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: customTheme,
      child: Container(
        width: double.infinity,
        // color: customTheme.colorScheme.secondary,
        color: Colors.grey.withOpacity(0.1),
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headerText,
                    style: TextStyle(
                      // color: Colors.white,
                      fontSize: (screenWidth * 0.04).clamp(14, 32),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
