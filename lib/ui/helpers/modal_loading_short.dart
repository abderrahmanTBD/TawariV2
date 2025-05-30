import 'package:flutter/material.dart';
import 'package:tawari/ui/themes/colors_tbd.dart';

void modalLoadingShort(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black45,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 150),
      content: const SizedBox(
        height: 40,
        width: 40,
        child: CircularProgressIndicator(color: ColorsTbd.primary),
      ),
    ),
  );
}
