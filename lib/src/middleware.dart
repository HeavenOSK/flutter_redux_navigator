import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'basics/basics.dart';

typedef NavigatorMiddewareCallback<S, T> = void Function(
  GlobalKey<NavigatorState> navigatorKey,
  Store<S> store,
  T action,
  NextDispatcher next,
);

/// A specialized [MiddlewareClass] in [Navigator] controls
/// which uses internally.
class _TypedNavigatorMiddleware<S, T> implements MiddlewareClass<S> {
  const _TypedNavigatorMiddleware({
    @required this.navigatorKey,
    @required this.callback,
  })  : assert(navigatorKey != null),
        assert(callback != null);

  final GlobalKey<NavigatorState> navigatorKey;
  final NavigatorMiddewareCallback<S, T> callback;

  @override
  void call(Store<S> store, dynamic action, NextDispatcher next) {
    if (action is T) {
      callback(navigatorKey, store, action, next);
    } else {
      next(action);
    }
  }
}

/// A callback specialized in [Navigator] related [Middleware]
/// which is executed when type of action defined [T] matched.
///
/// You can add custom behavior to [navigatorMiddleware] using
/// this.
class NavigatorMiddlewareBuilder<S, T> {
  const NavigatorMiddlewareBuilder({
    @required this.callback,
  }) : assert(callback != null);

  /// a callback which uses [NavigatorState] in middleware.
  final NavigatorMiddewareCallback<S, T> callback;

  _TypedNavigatorMiddleware<S, T> build(
      GlobalKey<NavigatorState> navigatorKey) {
    return _TypedNavigatorMiddleware<S, T>(
      navigatorKey: navigatorKey,
      callback: callback,
    );
  }
}

/// Returns list of [Navigator] controls related [Middleware].
List<Middleware<S>> navigatorMiddleware<S>(
  /// The [GlobalKey] for [Navigator] that you use. You need to set
  /// the same [GlobalKey] for here and [MaterialApp] or [Navigator] that
  /// you use.
  GlobalKey<NavigatorState> navigatorKey, {

  /// A list of custom [NavigatorMiddlewareBuilder].
  ///
  /// You can add more behavior by giving list of custom
  /// [NavigatorMiddlewareBuilder]. If you specify no callbacks, only
  /// [basicNavigatorCreator] will be used by default.
  List<NavigatorMiddlewareBuilder<S, dynamic>> additionalMiddlewareBuilders =
      const [],
}) {
  assert(additionalMiddlewareBuilders != null);

  final creators = basicNavigatorCreator<S>()
    ..addAll(additionalMiddlewareBuilders);
  return [
    ...creators.map(
      (callback) => callback.build(navigatorKey),
    ),
  ];
}
