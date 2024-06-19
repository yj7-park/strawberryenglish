import 'package:flutter/services.dart';
// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class SignupScreen2Input extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController birthDateController;

  const SignupScreen2Input({
    super.key,
    required this.nameController,
    required this.birthDateController,
  });

  @override
  SignupScreen2InputState createState() => SignupScreen2InputState();
}

class SignupScreen2InputState extends State<SignupScreen2Input> {
  Future<void> _selectDate(BuildContext context) async {
    String initialDate = widget.birthDateController.value.text;
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: customTheme
                    .colorScheme.secondary, // header background color
                onPrimary:
                    customTheme.colorScheme.onPrimary, // header text color
                onSurface: customTheme.colorScheme.onSurface, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor:
                      customTheme.colorScheme.primary, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: DateTime.tryParse(initialDate) ?? DateTime.now(),
        firstDate: DateTime(1950, 1),
        lastDate: DateTime(2030, 12));
    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);

      if (formattedDate != initialDate) {
        setState(() {
          widget.birthDateController.value =
              TextEditingValue(text: formattedDate);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: ((screenWidth - 500) / 2).clamp(20, double.nan),
      ),
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '필수 정보',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: widget.nameController,
              decoration: InputDecoration(
                labelText: '*한글 이름',
                border: const OutlineInputBorder(),
                enabledBorder: myOutlineInputBorder(widget.nameController),
                focusedBorder: myOutlineInputBorder(widget.nameController),
                labelStyle: TextStyle(
                  color: widget.nameController.text.isEmpty
                      ? Colors.redAccent
                      : Colors.black,
                ),
              ),
              onChanged: (_) {
                setState(() {});
              },
            ),
            const Text('* 실제 수강하는 사람의 이름을 적어주세요.'),
            const SizedBox(height: 30),
            TextFormField(
              controller: widget.birthDateController,
              decoration: InputDecoration(
                labelText: '*생년월일',
                // hintText: 'YYYY-MM-DD',
                border: const OutlineInputBorder(),
                enabledBorder: myOutlineInputBorder(widget.birthDateController),
                focusedBorder: myOutlineInputBorder(widget.birthDateController),
                labelStyle: TextStyle(
                  color: widget.birthDateController.text.isEmpty
                      ? Colors.redAccent
                      : Colors.black,
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp("[0-9-]"),
                ),
                // MaskedInputFormatter('####-##-##')
              ],
              onTap: () => _selectDate(context),
              onChanged: (_) {
                setState(() {});
              },
              textInputAction: TextInputAction.next,
            ),
          ],
        ),
      ),
    );
  }
}
