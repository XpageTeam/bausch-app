import 'package:bausch/sections/home/sections/may_be_interesting_section.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/white_rounded_container.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/sections/shops/shops_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/buttons/white_button.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:bausch/widgets/select_widgets/custom_radio.dart';
import 'package:bausch/widgets/text/text_with_point.dart';
import 'package:flutter/material.dart';

//Program
class ProgramScreen extends StatefulWidget {
  final ScrollController controller;
  const ProgramScreen({required this.controller, Key? key}) : super(key: key);

  @override
  State<ProgramScreen> createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {
  TextEditingController nameController = TextEditingController();
  int gValue = 0;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          controller: widget.controller,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                top: StaticData.sidePadding,
                left: StaticData.sidePadding,
                right: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Stack(
                      children: [
                        Image.asset('assets/program.png'),
                        CustomSliverAppbar.toClose(Container(), widget.key),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const InfoSection(
                      text:
                          'Получите сертификат на бесплатную диагностику зрения и первую пару контактных линз Bausch+Lomb. Специалисты салона оптики также научат вас надевать контактные линзы и ухаживать за ними. Если вам подойдут подобранные контактные линзы и вы захотите их приобрести, то за регистрацию кода с упаковки вы получите в два раза больше баллов. Главное, успеть сделать это в течение 14 дней после активации сертификата в оптике.',
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 40,
                      ),
                      child: MayBeInteresting(
                        text: 'В программе участвуют: ',
                      ),
                    ),
                    Text(
                      'Важно знать перед подбором',
                      style: AppStyles.h1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 40,
                        top: 20,
                      ),
                      child: WhiteRoundedContainer(
                        child: Column(
                          children: [
                            TextWithPoint(
                              text:
                                  'Перед подбором контактных линз проверка зрения обязательна.',
                              textStyle: AppStyles.p1,
                              dotStyle: AppStyles.p1,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextWithPoint(
                              text:
                                  'Бесплатная пара выдается оптикой при отсутствии медицинских противопоказаний.',
                              textStyle: AppStyles.p1,
                              dotStyle: AppStyles.p1,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextWithPoint(
                              text:
                                  'Надеть первую бесплатную пару линз вам поможет специалист. Подарочные линзы не выдаются в блистерной упаковке.',
                              textStyle: AppStyles.p1,
                              dotStyle: AppStyles.p1,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextWithPoint(
                              text:
                                  'Бесплатная пара выдается оптикой в случае наличия подходящих диоптрий.Если вы младше 18 лет, может потребоваться присутствие родителя.',
                              textStyle: AppStyles.p1,
                              dotStyle: AppStyles.p1,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextWithPoint(
                              text:
                                  'Дополнительные услуги, не входящие в сертификат, могут быть платными, уточняйте условия в оптике.',
                              textStyle: AppStyles.p1,
                              dotStyle: AppStyles.p1,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Text(
                      'Ваши данные',
                      style: AppStyles.h1,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    NativeTextInput(
                      labelText: 'Имя',
                      controller: TextEditingController(),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    NativeTextInput(
                      labelText: 'Фамилия',
                      controller: TextEditingController(),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    NativeTextInput(
                      labelText: 'E-mail',
                      controller: TextEditingController(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 40,
                        bottom: 20,
                      ),
                      child: Text(
                        'Чем пользуетесь для коррекции зрения',
                        style: AppStyles.h1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          gValue = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: StaticData.sidePadding,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                Models.whatYouUse[index],
                                style: AppStyles.h3,
                                maxLines: 3,
                              ),
                            ),
                            CustomRadio(
                              value: index,
                              groupValue: gValue,
                              onChanged: (v) {
                                setState(
                                  () {
                                    gValue = index;
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  childCount: Models.whatYouUse.length,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(
                      height: 24,
                    ),
                    WhiteButton(
                      text: 'Выбрать оптику',
                      padding: const EdgeInsets.fromLTRB(16, 26, 16, 28),
                      icon: Padding(
                        padding: const EdgeInsets.only(
                          right: 12,
                        ),
                        child: Image.asset(
                          'assets/icons/map-marker.png',
                          height: 16,
                        ),
                      ),
                      onPressed: () {
                        Keys.mainNav.currentState!
                            .push<void>(MaterialPageRoute(builder: (context) {
                          return const ShopsScreen();
                        }));
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomFloatingActionButton(
          text: 'Получить сертификат',
          onPressed: () {},
        ),
        //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
