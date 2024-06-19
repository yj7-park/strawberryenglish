import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class MyHeader extends StatelessWidget {
  final String headerText;

  const MyHeader(this.headerText, {super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double verticalPadding = (screenHeight * 0.05).clamp(25, 50);
    return Theme(
      data: customTheme,
      child: Container(
        width: double.infinity,
        // color: customTheme.colorScheme.secondary,
        color: Colors.grey.withOpacity(0.1),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headerText,
                style: const TextStyle(
                  // color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
