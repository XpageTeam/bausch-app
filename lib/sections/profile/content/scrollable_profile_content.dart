import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/sections/profile/content/models/base_order_model.dart';
import 'package:bausch/sections/profile/content/models/notification_model.dart';
import 'package:bausch/sections/profile/content/notifications_section.dart';
import 'package:bausch/sections/profile/content/orders_section.dart';
import 'package:bausch/sections/profile/content/wm/profile_content_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/error_page.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/select_widgets/select_widget.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ScrollableProfileContent extends CoreMwwmWidget<ProfileContentWM> {
  final ScrollController controller;
  final bool? showNotifications;
  ScrollableProfileContent({
    required this.controller,
    this.showNotifications = false,
    Key? key,
  }) : super(
          widgetModelBuilder: (_) => ProfileContentWM(),
          key: key,
        );

  @override
  WidgetState<CoreMwwmWidget<ProfileContentWM>, ProfileContentWM>
      createWidgetState() => _ScrollableProfileContentState();
}

class _ScrollableProfileContentState
    extends WidgetState<ScrollableProfileContent, ProfileContentWM> {
  bool isOrdersEnabled = true;

  @override
  void initState() {
    if (widget.showNotifications ?? false) {
      // wm.activeNotifications.stream.listen((event) { });

      isOrdersEnabled = false;

      // wm.activeNotifications.stream.listen((notificationsCount) {
      //   if (notificationsCount > 0){

      //     widget.controller.jumpTo(0);
      //   }
      // });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppTheme.mystic,
      child: EntityStateBuilder<bool>(
        streamedState: wm.allDataLoadingState,
        loadingChild: const Center(
          child: AnimatedLoader(),
        ),
        errorBuilder: (context, e) {
          e as CustomException;

          return Center(
            // color: Colors.pink,
            child: SimpleErrorWidget(
              title: e.title.replaceAll('-', '\u{2011}'),
              // subtitle: e.subtitle,
              buttonText: 'Обновить',
              buttonCallback: wm.allDataLoadAction,
            ),
          );
        },
        builder: (_, state) {
          return PullToRefreshNotification(
            refreshOffset: 40,
            maxDragOffset: 60,
            color: Colors.black,
            child: CustomScrollView(
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
                      child: StreamedStateBuilder<int>(
                        streamedState: wm.activeNotifications,
                        builder: (_, amount) {
                          if (amount < 0) {
                            setState(() {
                              isOrdersEnabled = true;

                              widget.controller.jumpTo(0);
                            });
                          }
                          return SelectWidget(
                            initValue: widget.showNotifications != null &&
                                    widget.showNotifications!
                                ? 1
                                : 0,
                            items: [
                              'Заказы ${wm.orderHistoryList.value.data!.length}',
                              'Уведомления ${amount > 0 ? amount : ''}',
                            ],
                            onChanged: (i) {
                              setState(() {
                                if (i == 0) {
                                  isOrdersEnabled = true;
                                } else {
                                  isOrdersEnabled = false;
                                }

                                widget.controller.jumpTo(0);
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                PullToRefreshContainer((info) {
                  return SliverList(
                    delegate: SliverChildListDelegate([
                      ClipRect(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: SizedBox(
                            height: info?.dragOffset ?? 0,
                            child: const Center(
                              child: AnimatedLoader(),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  );
                }),
                if (isOrdersEnabled) ...[
                  //* Вкладка с заказами
                  // if (wm.orderHistoryList.value.data == null)
                  //   SliverFillRemaining(
                  //     hasScrollBody: false,
                  //     child: Center(
                  //       child: SimpleErrorWidget(
                  //         title: 'Ошибка',
                  //         buttonCallback: () => wm.loadOrdersHistoryAction(),
                  //         buttonText: 'Повторить',
                  //       ),
                  //     ),
                  //   )
                  // else
                  //   OrdersSection(
                  //     ordersList: wm.orderHistoryList.value.data!,
                  //   ),

                  EntityStateBuilder<List<BaseOrderModel?>>(
                    streamedState: wm.orderHistoryList,
                    loadingBuilder: (context, data) => data == null
                        ? const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: AnimatedLoader(),
                            ),
                          )
                        : OrdersSection(
                            ordersList: data,
                          ),
                    errorBuilder: (context, error) => SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: SimpleErrorWidget(
                          title: 'Ошибка',
                          buttonCallback: () => wm.loadOrdersHistoryAction(),
                          buttonText: 'Повторить',
                        ),
                      ),
                    ),
                    builder: (_, orderHistoryList) => OrdersSection(
                      ordersList: orderHistoryList,
                    ),
                  ),
                ] else ...[
                  //* Вкладка с уведомлениями (с переключателем)
                  // if (wm.notificationsList.value.data == null)
                  // SliverFillRemaining(
                  //   hasScrollBody: false,
                  //   child: Center(
                  //     child: SimpleErrorWidget(
                  //       title: 'Ошибка',
                  //       buttonCallback: () => wm.loadNotificationsAction(),
                  //       buttonText: 'Повторить',
                  //     ),
                  //   ),
                  // )
                  // else
                  //   NotificationSection(
                  //     items: wm.notificationsList.value.data!,
                  //     updateCallback: (amount) =>
                  //         wm.updateNotificationsAmount(amount),
                  //   ),

                  EntityStateBuilder<List<NotificationModel>>(
                    streamedState: wm.notificationsList,
                    loadingBuilder: (context, data) => data == null
                        ? const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: AnimatedLoader(),
                            ),
                          )
                        : NotificationSection(
                            items: data,
                            updateCallback: (amount) =>
                                wm.updateNotificationsAmount(amount),
                          ),
                    errorBuilder: (context, error) => SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: SimpleErrorWidget(
                          title: 'Ошибка',
                          buttonCallback: () => wm.loadNotificationsAction(),
                          buttonText: 'Повторить',
                        ),
                      ),
                    ),
                    builder: (_, notificationsList) => NotificationSection(
                      items: notificationsList,
                      updateCallback: (amount) =>
                          wm.updateNotificationsAmount(amount),
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
            ),
            onRefresh: () {
              return isOrdersEnabled
                  ? wm.refreshOrders()
                  : wm.refreshNotifications();
            },
          );
        },
      ),
    );
  }
}
