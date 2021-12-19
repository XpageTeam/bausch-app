import 'package:bausch/sections/faq/social_buttons/cubit/social_cubit.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';


class SocialButtons extends StatefulWidget {
  const SocialButtons({Key? key}) : super(key: key);

  @override
  State<SocialButtons> createState() => _SocialButtonsState();
}

class _SocialButtonsState extends State<SocialButtons> {
  final SocialCubit socialCubit = SocialCubit();
  List<String> logos = [
    'assets/logos/vk.png',
    'assets/logos/tube.png',
    'assets/logos/inst.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 40,
            bottom: 14,
          ),
          child: Text(
            'Вы можете найти нас здесь',
            style: AppStyles.p1,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 45,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              return CircleAvatar(
                backgroundColor: Colors.white,
                radius: 22,
                child: IconButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  icon: Image.asset(
                    logos[i],
                    height: 16,
                  ),
                ),
              );
            },
            separatorBuilder: (context, i) {
              return const SizedBox(
                width: 30,
              );
            },
            itemCount: logos.length,
          ),
        ),
      ],
    );
  }
}

