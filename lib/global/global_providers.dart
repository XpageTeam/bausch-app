import 'package:bausch/global/login/login_wm.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class GlobalProviders extends StatefulWidget {
  final Widget child;

  const GlobalProviders({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  State<GlobalProviders> createState() => _GlobalProvidersState();
}

class _GlobalProvidersState extends State<GlobalProviders> {
  late LoginWM loginWM;

  @override
  void dispose() {
    loginWM.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    RequestHandler.setContext(ctx);
    
    return MultiProvider(
      providers: [
        // Provider(
        //   create: (context) {
        //     authWM = AuthWM(const WidgetModelDependencies());
        //   },
        // ),
        Provider(
          create: (context) {
            loginWM = LoginWM(
              baseDependencies: const WidgetModelDependencies(),
              context: context,
            );

            return loginWM;
          },
          lazy: false,
        ),
      ],
      child: widget.child,
    );
  }
}
