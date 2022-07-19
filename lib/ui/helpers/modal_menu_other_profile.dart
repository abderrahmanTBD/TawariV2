import 'package:flutter/material.dart';
import 'package:tawari/ui/helpers/modal_profile_settings.dart';

modalMenuOtherProfile(BuildContext context, Size size) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadiusDirectional.vertical(top: Radius.circular(20.0))),
    backgroundColor: Colors.white,
    builder: (context) => Container(
      height: size.height * .48,
      width: size.width,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadiusDirectional.vertical(top: Radius.circular(20.0))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(50.0)),
              ),
            ),
            const SizedBox(height: 10.0),
            Item(
              icon: Icons.report,
              text: 'Report...',
              size: size,
              onPressed: () {},
            ),
            Item(
              icon: Icons.block,
              text: 'Block',
              size: size,
              onPressed: () {},
            ),
            Item(
              icon: Icons.remove_circle_outline_rounded,
              text: 'Restrict',
              size: size,
              onPressed: () {},
            ),
            Item(
              icon: Icons.visibility_off_outlined,
              text: 'hide your story',
              size: size,
              onPressed: () {},
            ),
            Item(
              icon: Icons.copy_all_rounded,
              text: 'Copy profile URL',
              size: size,
              onPressed: () {},
            ),
            Item(
              icon: Icons.send,
              text: 'Send Message',
              size: size,
              onPressed: () {},
            ),
            Item(
              icon: Icons.share_outlined,
              text: 'share this profile',
              size: size,
              onPressed: () {},
            ),
          ],
        ),
      ),
    ),
  );
}
