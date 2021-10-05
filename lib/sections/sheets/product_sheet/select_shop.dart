import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class SelectShopSection extends StatefulWidget {
  const SelectShopSection({Key? key}) : super(key: key);

  @override
  State<SelectShopSection> createState() => _SelectShopSectionState();
}

class _SelectShopSectionState extends State<SelectShopSection> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: TextButton(
            onPressed: () {
              setState(() {
                _selectedIndex = i;
              });
            },
            style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Линз Сервис',
                      style: AppStyles.h3,
                    ),
                    Text(
                      'lensservice.ru',
                      style: AppStyles.p1Underlined,
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Image.asset(
                  'assets/ochkov-net.png',
                  width: MediaQuery.of(context).size.width / 5,
                ),
                Radio(
                    value: i,
                    groupValue: _selectedIndex,
                    onChanged: (v) {
                      setState(() {
                        _selectedIndex = v as int;
                      });
                    })
              ],
            ),
          ),
        ),
        childCount: 4,
      ),
    );
  }
}
