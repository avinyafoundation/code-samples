import 'dart:developer';

import 'package:ShoolManagementSystem/src/data/campus_feedback_system.dart';
import 'package:flutter/material.dart';

import 'auth.dart';
import 'routing.dart';
import 'screens/navigator.dart';

class CampusConfigManagementSystem extends StatefulWidget {
  const CampusConfigManagementSystem({super.key});

  @override
  State<CampusConfigManagementSystem> createState() =>
      _CampusConfigManagementSystemState();
}

class _CampusConfigManagementSystemState
    extends State<CampusConfigManagementSystem> {
  final _auth = SMSAuth();
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final RouteState _routeState;
  late final SimpleRouterDelegate _routerDelegate;
  late final TemplateRouteParser _routeParser;

  @override
  void initState() {
    /// Configure the parser with all of the app's allowed path templates.
    _routeParser = TemplateRouteParser(
      allowedPaths: [
        '/signin',
        '/avinya_types/new',
        '/avinya_types/all',
        '/avinya_types/popular',
        '/avinya_type/:id',
        '/avinya_type/new',
        '/avinya_type/edit',
        '/evaluations/new',
        '/evaluations/all',
        '/evaluations/popular',
        '/evaluation/:id',
        '/evaluation/new',
        '/evaluation/edit',
        '/#access_token',
      ],
      guard: _guard,
      initialRoute: '/signin',
    );

    _routeState = RouteState(_routeParser);

    _routerDelegate = SimpleRouterDelegate(
      routeState: _routeState,
      navigatorKey: _navigatorKey,
      builder: (context) => SMSNavigator(
        navigatorKey: _navigatorKey,
      ),
    );

    // Listen for when the user logs out and display the signin screen.
    _auth.addListener(_handleAuthStateChanged);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => RouteStateScope(
        notifier: _routeState,
        child: SMSAuthScope(
          notifier: _auth,
          child: MaterialApp.router(
            routerDelegate: _routerDelegate,
            routeInformationParser: _routeParser,
            // Revert back to pre-Flutter-2.5 transition behavior:
            // https://github.com/flutter/flutter/issues/82053
            theme: ThemeData(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
                },
              ),
            ),
          ),
        ),
      );

  Future<ParsedRoute> _guard(ParsedRoute from) async {
    final signedIn = await _auth.getSignedIn();
    String? jwt_sub = campusFeedbackSystemInstance.getJWTSub();

    final signInRoute = ParsedRoute('/signin', '/signin', {}, {});

    final avinyaTypesRoute =
        ParsedRoute('/avinya_types', '/avinya_types', {}, {});

    final evaluationsRoute =
        ParsedRoute('/evaluations', '/evaluations', {}, {});

    // // Go to /apply if the user is not signed in
    log("_guard signed in $signedIn");
    // log("_guard JWT sub ${jwt_sub}");
    log("_guard from ${from.toString()}\n");

    if (signedIn && from == avinyaTypesRoute) {
      return avinyaTypesRoute;
    } else if (signedIn && from == evaluationsRoute) {
      return evaluationsRoute;
    }
    // Go to /application if the user is signed in and tries to go to /signin.
    else if (signedIn && from == signInRoute) {
      return ParsedRoute('/avinya_types', '/avinya_types', {}, {});
    }
    // else if (signedIn && jwt_sub != null) {
    //   return avinyaTypesRoute;
    // }
    return from;
  }

  void _handleAuthStateChanged() async {
    bool signedIn = await _auth.getSignedIn();
    if (!signedIn) {
      _routeState.go('/signin');
    }
  }

  @override
  void dispose() {
    _auth.removeListener(_handleAuthStateChanged);
    _routeState.dispose();
    _routerDelegate.dispose();
    super.dispose();
  }
}
