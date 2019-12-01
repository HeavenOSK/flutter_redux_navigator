import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'basics/basics.dart';

/// A builder of [NavigatorMiddleware].
///
/// You can define [Navigator] related procedure thorough [callback] parameter.
///
/// When navigatorMiddleware is called,  [build] method will be called with
/// an injected navigatorKey.
class NavigatorMiddlewareBuilder<S, T>
    extends InjectableMiddlewareBuilder<S, T, GlobalKey<NavigatorState>> {
  const NavigatorMiddlewareBuilder({
    @required
        InjectableMiddlewareCallback<S, T, GlobalKey<NavigatorState>> callback,
  })  : assert(callback != null),
        super(callback: callback);
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
  return InjectableMiddleware<S, GlobalKey<NavigatorState>>(
    builders: [
      ...basicNavigatorBuilders<S>(),
      ...customBuilders,
    ],
  )(navigatorKey);
}
