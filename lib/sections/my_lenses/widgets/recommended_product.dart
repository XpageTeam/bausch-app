import 'dart:async';
import 'dart:io';

import 'package:bausch/models/my_lenses/recommended_products_list_modul.dart';
import 'package:bausch/packages/bottom_sheet/src/flexible_bottom_sheet_route.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/recommended_product_sheet.dart';
import 'package:bausch/sections/sheets/sheet.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:bausch/widgets/error_page.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecommendedProduct extends StatelessWidget {
  final RecommendedProductModel product;
  const RecommendedProduct({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showFlexibleBottomSheet<void>(
          minHeight: 0,
          initHeight: 0.95,
          maxHeight: 0.95,
          anchors: [0, 0.6, 0.95],
          context: context,
          builder: (context, controller, d) {
            return SheetWidget(
              child: RecommendedProductSheet(
                controller: controller,
                product: product,
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 4,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width / 2 -
              StaticData.sidePadding -
              2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 100,
                child: AspectRatio(
                  aspectRatio: 37 / 12,
                  child: ExtendedImage.network(
                    product.image,
                    printError: false,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                product.name,
                style: AppStyles.p1,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Padding(
                padding: const EdgeInsets.only(top: StaticData.sidePadding),
                child: GreyButton(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  text: 'Где купить',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => SimpleWebViewWidget(
                          url: product.link,
                        ),
                      ),
                    );
                    // if (await canLaunchUrlString(product.link)) {
                    //   await launchUrlString(
                    //     product.link,
                    //     mode: LaunchMode.inAppWebView,
                    //   );
                    // }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleWebViewWidget extends StatefulWidget {
  final String url;

  const SimpleWebViewWidget({super.key, required this.url});

  @override
  SimpleWebViewWidgetState createState() => SimpleWebViewWidgetState();
}

class SimpleWebViewWidgetState extends State<SimpleWebViewWidget> {
  final isLoadingState = StreamedState<bool>(true);
  final isErrorState = StreamedState<bool>(false);

  WebViewController? webViewController;
  bool isFirstPage = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final canGoBack =
            webViewController != null && await webViewController!.canGoBack();

        if (canGoBack) {
          unawaited(webViewController?.goBack());
          return Future(() => false);
        }

        return Future(() => true);
      },
      child: ColoredBox(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: StreamedStateBuilder<bool>(
              streamedState: isErrorState,
              builder: (_, isError) {
                return StreamedStateBuilder<bool>(
                  streamedState: isLoadingState,
                  builder: (_, isLoading) {
                    return Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: WebView(
                                initialUrl: widget.url,
                                javascriptMode: JavascriptMode.unrestricted,
                                onWebViewCreated: onWebViewCreated,
                                onPageStarted: onPageStarted,
                                onProgress: onProgress,
                                onPageFinished: onPageFinished,
                                onWebResourceError: onError,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                        if (isFirstPage && isLoading)
                          const ColoredBox(
                            color: AppTheme.mystic,
                            child: Center(
                              child: AnimatedLoader(),
                            ),
                          ),
                        if (isError)
                          Center(
                            child: ErrorPage(
                              title: 'Не удалось загрузить страницу',
                              buttonText: 'Обновить',
                              buttonCallback: webViewController?.reload,
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void onWebViewCreated(WebViewController controller) {
    webViewController = controller;
  }

  void onPageStarted(String url) {
    isErrorState.accept(false);
    isLoadingState.accept(true);
    isFirstPage = false;
  }

  void onPageFinished(String url) {
    isLoadingState.accept(false);
  }

  void onProgress(int progress) {
    debugPrint('progress: $progress');
    if (progress > 70) {
      isLoadingState.accept(false);
    }
  }

  void onError(WebResourceError error) {
    isLoadingState.accept(false);
    isErrorState.accept(true);
  }
}
