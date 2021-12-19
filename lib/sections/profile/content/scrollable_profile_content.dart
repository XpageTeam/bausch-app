import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/sections/profile/content/notifications_section.dart';
import 'package:bausch/sections/profile/content/orders_section.dart';
import 'package:bausch/sections/profile/content/wm/profile_content_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/error_page.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/select_widgets/select_widget.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ScrollableProfileContent extends CoreMwwmWidget<ProfileContentWM> {
  final ScrollController controller;
  ScrollableProfileContent({required this.controller, Key? key})
      : super(
          widgetModelBuilder: (context) {
            return ProfileContentWM();
          },
          key: key,
        );

  @override
  WidgetState<CoreMwwmWidget<ProfileContentWM>, ProfileContentWM>
      createWidgetState() => _ScrollableProfileContentState();
}

class _ScrollableProfileContentState
    extends WidgetState<ScrollableProfileContent, ProfileContentWM> {
  bool isOrdersEnabled = true;

  int groupChecked = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.mystic,
      child: EntityStateBuilder<bool>(
        streamedState: wm.allDataLoadingState,
        loadingChild: const Center(
          child: AnimatedLoader(),
        ),
        errorBuilder: (context, e) {
          e as CustomException;

          return ErrorPage(
            title: e.title,
            subtitle: e.subtitle,
            buttonText: 'Обновить',
            buttonCallback: wm.allDataLoadAction,
          );
        },
        builder: (_, state) {
          return CustomScrollView(
            controller: widget.controller,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                leading: Container(),
                backgroundColor: Colors.transparent,
                toolbarHeight: 80,
                excludeHeaderSemantics: true,
                automaticallyImplyLeading: false,
                pinned: true,
                elevation: 0,
                flexibleSpace: Container(
                  color: AppTheme.mystic,
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                    left: StaticData.sidePadding,
                    right: StaticData.sidePadding,
                  ),
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    child: SelectWidget(
                      items: [
                        if (wm.orderHistoryList.value.data != null)
                          'Заказы ${wm.orderHistoryList.value.data!.isNotEmpty ? wm.orderHistoryList.value.data!.length : ''}',
                        'Уведомления 8',
                      ],
                      onChanged: (i) {
                        if (i == 0) {
                          setState(() {
                            isOrdersEnabled = true;
                          });
                        } else {
                          setState(() {
                            isOrdersEnabled = false;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
              if (isOrdersEnabled) ...[
                //* Вкладка с заказами
                OrdersSection(
                  ordersList: wm.orderHistoryList.value.data!,
                ),
              ] else ...[
                //* Вкладка с уведомлениями (с переключателем)
                NotificationSection(
                  groupChecked: groupChecked,
                  onChanged: (newGroupChecked) => setState(
                    () {
                      groupChecked = newGroupChecked;
                    },
                  ),
                ),
              ],
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
