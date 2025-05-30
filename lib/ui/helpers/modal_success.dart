import 'package:flutter/material.dart';
import 'package:tawari/ui/themes/colors_tbd.dart';
import 'package:tawari/ui/widgets/widgets.dart';

void modalSuccess(BuildContext context, String text,
    {required VoidCallback onPressed}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black12,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: SizedBox(
        height: 250,
        child: Column(
          children: [
            Row(
              children: const [
                TextCustom(
                    text: 'Tawari',
                    color: ColorsTbd.primary,
                    fontWeight: FontWeight.w500),
                TextCustom(text: ' Network', fontWeight: FontWeight.w500),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10.0),
            Container(
              height: 90,
              width: 90,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      colors: [Colors.white, ColorsTbd.primary])),
              child: Container(
                margin: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: ColorsTbd.primary),
                child: const Icon(Icons.check, color: Colors.white, size: 38),
              ),
            ),
            const SizedBox(height: 35.0),
            TextCustom(text: text, fontSize: 17, fontWeight: FontWeight.w400),
            const SizedBox(height: 20.0),
            InkWell(
              onTap: onPressed,
              child: Container(
                alignment: Alignment.center,
                height: 35,
                width: 150,
                decoration: BoxDecoration(
                    color: ColorsTbd.primary,
                    borderRadius: BorderRadius.circular(5.0)),
                child: const TextCustom(
                    text: 'Done', color: Colors.white, fontSize: 17),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
