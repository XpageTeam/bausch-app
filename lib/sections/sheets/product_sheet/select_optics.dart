import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/select_widgets/custom_radio.dart';
import 'package:flutter/material.dart';

class SelectOpticsSection extends StatefulWidget {
  const SelectOpticsSection({Key? key}) : super(key: key);

  @override
  State<SelectOpticsSection> createState() => _SelectOpticsSectionState();
}

class _SelectOpticsSectionState extends State<SelectOpticsSection> {
  List<String> optics = [
    'ЛинзСервис',
    'Оптика-А',
    'Мой взгляд',
    'Медиком',
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: SizedBox(
            height: 74,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = i;
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                splashFactory: NoSplash.splashFactory,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          optics[i],
                          style: AppStyles.h2,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Image.asset(
                      'assets/ochkov-net.png',
                      width: MediaQuery.of(context).size.width / 5,
                    ),
                    CustomRadio(
                      value: i,
                      groupValue: _selectedIndex,
                      onChanged: (v) {
                        setState(() {
                          _selectedIndex = i;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        childCount: optics.length,
      ),
    );
  }
}
