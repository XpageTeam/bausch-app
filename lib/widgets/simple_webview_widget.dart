import 'dart:async';
import 'dart:io';

import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/error_page.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Виджет-страница, которую надо пушить, если есть url
///
/// Также открывает pdf
class SimpleWebViewWidget extends StatefulWidget {
  final String url;

  const SimpleWebViewWidget({required this.url, super.key});

  @override
  SimpleWebViewWidgetState createState() => SimpleWebViewWidgetState();
}

class SimpleWebViewWidgetState extends State<SimpleWebViewWidget> {
  /// Состояние загрузки
  final isLoadingState = StreamedState<bool>(true);

  /// Состояние ошибки
  final isErrorState = StreamedState<bool>(false);

  /// Для сохранения pdf в кэше
  final cacheManager = DefaultCacheManager();

  /// Файл или веб-страница
  bool isFile = true;

  /// Путь до файла
  String filePath = '';

  /// Флаг, который нужен, чтобы загрузка отображалась только тогда, когда происходит загрузка первой страницы
  bool isFirstPage = true;

  /// Контроллер для управления webView
  WebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    isFile = widget.url.endsWith('.pdf');

    if (isFile) {
      _loadPdfFile();
    }

    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }

    if (Platform.isIOS) {
      WebView.platform = CupertinoWebView();
    }
  }

  @override
  void dispose() {
    isLoadingState.dispose();
    isErrorState.dispose();
    cacheManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('url: ${widget.url}');
    return WillPopScope(
      onWillPop: () async {
        final canGoBack = webViewController != null &&
            await webViewController!.canGoBack() &&
            !isFile;

        if (canGoBack) {
          unawaited(webViewController?.goBack());
          return Future(() => false);
        }

        return Future(() => true);
      },
      child: ColoredBox(
        color: AppTheme.mystic,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: AppTheme.mystic,
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(54),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: StaticData.sidePadding,
                    ),
                    child: Row(
                      children: [
                        NormalIconButton(
                          isAnimated: false,
                          onPressed: Navigator.of(context).pop,
                          icon: const Icon(
                            Icons.chevron_left_rounded,
                            size: 20,
                            color: AppTheme.mineShaft,
                          ),
                          // backgroundColor: iconColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            body: StreamedStateBuilder<bool>(
              streamedState: isErrorState,
              builder: (_, isError) {
                return StreamedStateBuilder<bool>(
                  streamedState: isLoadingState,
                  builder: (_, isLoading) {
                    debugPrint('isFile: $isFile isLoading: $isLoading');
                    return Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: isFile
                                  ? isLoading || isError
                                      ? const SizedBox()
                                      : PdfView(
                                          path: filePath,
                                        )
                                  : WebView(
                                      initialUrl: widget.url,
                                      javascriptMode:
                                          JavascriptMode.unrestricted,
                                      onWebViewCreated: onWebViewCreated,
                                      onPageStarted: onLoadStarted,
                                      onPageFinished: onLoadFinished,
                                      onWebResourceError: onError,
                                      // javascriptChannels: <JavascriptChannel>{
                                      //   _onTap(context),
                                      // },
                                    ),
                            ),
                            // if (!isFile) const SizedBox(height: 20),
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
                            child: SimpleErrorWidget(
                              title: 'Не удалось загрузить страницу',
                              buttonText: 'Обновить',
                              buttonCallback: () {
                                if (isFile) {
                                  _loadPdfFile();
                                } else {
                                  webViewController?.reload();
                                }
                              },
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

  // ignore: use_setters_to_change_properties
  void onWebViewCreated(WebViewController controller) {
    webViewController = controller;
  }

  void onLoadStarted([String? url]) {
    debugPrint('onPageStarted: $url');
    isErrorState.accept(false);
    isLoadingState.accept(true);
  }

  void onLoadFinished([String? url]) {
    isFirstPage = false;
    isLoadingState.accept(false);
    debugPrint('onPageFinished');
    // webViewController?.runJavascript('alert(\'asdasd\')');
  }

  void onError([WebResourceError? error]) {
    isLoadingState.accept(false);
    isErrorState.accept(true);
  }

  Future<void> _loadPdfFile() async {
    try {
      onLoadStarted();
      final file = await cacheManager.getSingleFile(widget.url);
      filePath = file.path;
      onLoadFinished();
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      onError();
    }
  }

  // JavascriptChannel _onTap(BuildContext context) {
  //   return JavascriptChannel(
  //     name: 'Button',
  //     onMessageReceived: (message) {
  //       Navigator.of(context).pop();
  //     },
  //   );
  // }
}

void openSimpleWebView(BuildContext context, {required String url}) {
  final page = SimpleWebViewWidget(
    url: url,
  );

  final pageRoute = Platform.isIOS
      ? CupertinoPageRoute<void>(builder: (_) => page)
      : MaterialPageRoute<void>(builder: (_) => page);

  Navigator.of(context).push(pageRoute);
}
