import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class OrderAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  const OrderAppBar({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Material(
        color: AppTheme.mystic,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(
                  left: 12,
                ),
                child: NormalIconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.chevron_left_rounded,
                    size: 20,
                    color: AppTheme.mineShaft,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: Text(
                  title,
                  style: AppStyles.h2Bold,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 48);
}

class NormalIconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback? onPressed;
  const NormalIconButton({
    required this.icon,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Material(
        clipBehavior: Clip.hardEdge,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () {
            debugPrint('tapped');
          },
          child: icon,
        ),
        color: Colors.transparent,
      ),
    );
  }
}
