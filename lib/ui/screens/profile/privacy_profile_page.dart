import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawari/domain/blocs/blocs.dart';
import 'package:tawari/ui/helpers/helpers.dart';
import 'package:tawari/ui/screens/profile/widgets/item_profile.dart';
import 'package:tawari/ui/themes/colors_tbd.dart';
import 'package:tawari/ui/widgets/widgets.dart';

class PrivacyProgilePage extends StatelessWidget {
  const PrivacyProgilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is LoadingChangeAccount) {
          modalLoading(context, 'Changing privacy...');
        } else if (state is FailureUserState) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        } else if (state is SuccessUserState) {
          Navigator.pop(context);
          modalSuccess(context, 'Privacy changed!',
              onPressed: () => Navigator.pop(context));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const TextCustom(
              text: 'Privacy', fontSize: 19, fontWeight: FontWeight.w500),
          elevation: 0,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.black)),
        ),
        body: SafeArea(
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            physics: const BouncingScrollPhysics(),
            children: [
              const TextCustom(
                  text: 'Account privacy',
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: InkWell(
                  child: BlocBuilder<UserBloc, UserState>(
                    buildWhen: (previous, current) => previous != current,
                    builder: (_, state) => Row(
                      children: [
                        const Icon(Icons.lock_outlined),
                        const SizedBox(width: 10),
                        const TextCustom(text: 'Private account', fontSize: 17),
                        const Spacer(),
                        (state.user != null && state.user!.isPrivate == 1)
                            ? const Icon(Icons.radio_button_checked_rounded,
                                color: ColorsTbd.primary)
                            : const Icon(Icons.radio_button_unchecked_rounded),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  onTap: () => modalPrivacyProfile(context),
                ),
              ),
              const Divider(),
              const SizedBox(height: 10.0),
              const TextCustom(
                  text: 'Interactions',
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              const SizedBox(height: 10.0),
              ItemProfile(
                  text: 'Comments',
                  icon: Icons.chat_bubble_outline_rounded,
                  onPressed: () {}),
              ItemProfile(
                  text: 'Post', icon: Icons.add_box_outlined, onPressed: () {}),
              ItemProfile(
                  text: 'Mentions',
                  icon: Icons.alternate_email_sharp,
                  onPressed: () {}),
              ItemProfile(
                  text: 'Stories',
                  icon: Icons.control_point_duplicate_rounded,
                  onPressed: () {}),
              ItemProfile(
                  text: 'Messages', icon: Icons.send_rounded, onPressed: () {}),
              const Divider(),
              const SizedBox(height: 10.0),
              const TextCustom(
                  text: 'Connections',
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              const SizedBox(height: 10.0),
              ItemProfile(
                  text: 'Restrict accounts',
                  icon: Icons.no_accounts_outlined,
                  onPressed: () {}),
              ItemProfile(
                  text: 'block accounts',
                  icon: Icons.highlight_off_rounded,
                  onPressed: () {}),
              ItemProfile(
                  text: 'mute accounts',
                  icon: Icons.notifications_off_outlined,
                  onPressed: () {}),
              ItemProfile(
                  text: 'Accounts you follow',
                  icon: Icons.people_alt_outlined,
                  onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
