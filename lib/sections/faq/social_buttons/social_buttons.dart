import 'package:bausch/help/utils.dart';
import 'package:bausch/sections/faq/social_buttons/cubit/social_cubit.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:extended_image/extended_image.dart';
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
                        onPressed: () {
                          //debugPrint(state.models[i].url);
                          Utils.tryLaunchUrl(
                            rawUrl: state.models[i].url,
                            onError: (ex) {
                              showDefaultNotification(
                                title: ex.title,
                                subtitle: ex.subtitle,
                              );
                            },
                          );
                        },
                        padding: EdgeInsets.zero,
                        icon: ExtendedImage.network(
                          state.models[i].icon,
                          height: 16,
                          printError: false,
                          loadStateChanged: loadStateChangedFunction,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, i) {
                    return const SizedBox(
                      width: 30,
                    );
                  },
                  itemCount: state.models.length,
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
