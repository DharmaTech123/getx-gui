import 'package:flutter/material.dart';
import 'package:getx_gui/data/app_colors.dart';

class AppButton extends StatelessWidget {
  AppButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  VoidCallback onPressed;
  String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 40,
      decoration: const BoxDecoration(
        color: AppColors.kDFE6D5,
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: const Text('Submit'),
      ),
    );
  }
}
