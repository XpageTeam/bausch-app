import 'package:bausch/help/utils.dart';
import 'package:bausch/models/faq/social_model.dart';
import 'package:bausch/sections/faq/social_buttons/cubit/social_cubit.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialButtons extends StatefulWidget {
  const SocialButtons({Key? key}) : super(key: key);

  @override
  State<SocialButtons> createState() => _SocialButtonsState();
}

class _SocialButtonsState extends State<SocialButtons> {
  final SocialCubit socialCubit = SocialCubit();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialCubit, SocialState>(
      bloc: socialCubit,
      builder: (context, state) {
        if (state is SocialSuccess) {
          final socialLinks = state.models;

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 40,
                  bottom: 14,
                ),
                child: Text(
                  'Вы можете найти нас здесь',
                  style: AppStyles.p1,
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  socialLinks.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      left: index != 0 ? 30.0 : 0,
                    ),
                    child: SocialButton(
                      model: socialLinks[index],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox(
          height: 99,
        );
      },
    );
  }
}

class SocialButton extends StatelessWidget {
  final SocialModel model;
  final double size;

  const SocialButton({
    required this.model,
    this.size = 45,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Utils.tryLaunchUrl(
          rawUrl: model.url,
          onError: (ex) {
            showDefaultNotification(
              title: ex.title,
              // subtitle: ex.subtitle,
            );
          },
        );
      },
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            size / 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            15.0,
          ),
          child: Image.network(
            model.icon,
          ),
        ),
      ),
    );
  }
}
