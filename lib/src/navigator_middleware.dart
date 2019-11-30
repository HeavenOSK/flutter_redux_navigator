import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'basics/basics.dart';
import 'middleware.dart';

/// Returns list of [Navigator] controls related [Middleware].
Iterable<Middleware<S>> navigatorMiddleware<S>(
  /// The [GlobalKey] for [Navigator] that you use. You need to set
  /// the same [GlobalKey] for here and [MaterialApp] or [Navigator] that
  /// you use.
  GlobalKey<NavigatorState> navigatorKey, {

  /// A list of custom [CallbackNavigatorMiddlewareBuilder].
  ///
  /// You can add more behavior by giving list of custom
  /// [CallbackNavigatorMiddlewareBuilder]. If you specify no callbacks, only
  /// [basicNavigatorBuilders] will be used by default.
  List<NavigatorMiddlewareBuilder<S, dynamic>> additionalMiddlewareBuilders =
      const [],
}) {
  assert(additionalMiddlewareBuilders != null);
  return [
    ...basicNavigatorBuilders<S>().map(
      (builder) => builder.build(navigatorKey),
    ),
    ...additionalMiddlewareBuilders.map(
      (builder) => builder.build(navigatorKey),
    ),
  ];
}
