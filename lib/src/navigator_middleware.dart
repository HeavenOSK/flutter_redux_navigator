import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'basics/basics.dart';

/// A callback of [Navigator] related procedure.
typedef NavigatorMiddlewareCallback<S, T> = void Function(
  GlobalKey<NavigatorState> navigatorKey,
  Store<S> store,
  T action,
  NextDispatcher next,
);

/// A middleware which can call [Navigator] related methods.
class NavigatorMiddleware<S, T> implements MiddlewareClass<S> {
  const NavigatorMiddleware({
    @required this.navigatorKey,
    @required this.callback,
  })  : assert(navigatorKey != null),
        assert(callback != null);

  /// A key to call [Navigator] related methods.
  final GlobalKey<NavigatorState> navigatorKey;

  /// A callback of [Navigator] related procedure.
  final NavigatorMiddlewareCallback<S, T> callback;

  @override
  void call(Store<S> store, dynamic action, NextDispatcher next) {
    if (action is T) {
      callback(navigatorKey, store, action, next);
    } else {
      next(action);
    }
  }
}

/// A builder of [NavigatorMiddleware].
///
/// You can define [Navigator] related procedure thorough [callback] parameter.
///
/// When navigatorMiddleware is called,  [build] method will be called with
/// an injected navigatorKey.
class NavigatorMiddlewareBuilder<S, T> {
  NavigatorMiddlewareBuilder({
    @required this.callback,
  }) : assert(callback != null);

  /// A callback for [NavigatorMiddleware].
  final NavigatorMiddlewareCallback<S, T> callback;

  /// A function of building [NavigatorMiddleware].
  NavigatorMiddleware<S, T> build(GlobalKey<NavigatorState> navigatorKey) {
    return NavigatorMiddleware<S, T>(
      navigatorKey: navigatorKey,
      callback: callback,
    );
  }
}

/// Returns list of [Navigator] controls related [Middleware].
Iterable<Middleware<S>> navigatorMiddleware<S>(
  /// The [GlobalKey] for [Navigator] that you use. You need to set
  /// the same [GlobalKey] for here and [MaterialApp] or [Navigator] that
  /// you use.
  GlobalKey<NavigatorState> navigatorKey, {

  /// A list of custom [NavigatorMiddlewareBuilder].
  ///
  /// You can add more behavior by giving list of custom
  /// [NavigatorMiddlewareBuilder]. If you specify no customBuilders,
  /// this method represents basic navigator related middleware.
  List<NavigatorMiddlewareBuilder<S, dynamic>> customBuilders = const [],
}) {
  assert(customBuilders != null);
  return [
    ...basicNavigatorBuilders<S>().map(
      (builder) => builder.build(navigatorKey),
    ),
    ...customBuilders.map(
      (builder) => builder.build(navigatorKey),
    ),
  ];
}
