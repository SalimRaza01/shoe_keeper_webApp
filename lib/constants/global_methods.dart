import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

SvgPicture getSvgIcon(
  String assetPath, {
  double? width,
  double? height,
  Color? color,
  BoxFit fit = BoxFit.contain,
}) {
  return SvgPicture.asset(
    assetPath,
    width: width,
    height: height,
    colorFilter:
        color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    fit: fit,
  );
}


void showSnackBar(BuildContext context, String message) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(10),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            print('Undo action clicked');
          },
          textColor: Colors.white,
        ),
      ),
    );
  }
}
