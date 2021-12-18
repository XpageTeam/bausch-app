import 'package:bausch/global/login/login_wm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    
    
    return MultiProvider(
      providers: [
        // Provider(
        //   create: (context) {
        //     authWM = AuthWM(const WidgetModelDependencies());
        //   },
        // ),
        Provider(
          create: (context) {
            // loginWM = ;

            return loginWM;
          },
          lazy: false,
        ),
      ],
      child: widget.child,
    );
  }
}
