import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import 'basics/basics.dart';

/// A callback specialized in [Navigator] related [Middleware]
/// which is executed when type of action defined [T] matched.
///
/// You can add custom behavior to [navigatorMiddleware] using
/// this.
class NavigatorMiddlewareCallback<S, T> {
  const NavigatorMiddlewareCallback({
    @required this.callback,
  }) : assert(callback != null);

  /// a callback which uses [NavigatorState] in middleware.
  final void Function(
    GlobalKey<NavigatorState> navigatorKey,
    Store<S> store,
    T action,
    NextDispatcher next,
  ) callback;

  /// Lets [callback] Act as a function in middleware.
  void call(
    GlobalKey<NavigatorState> navigatorKey,
    Store<S> store,
    T action,
    NextDispatcher next,
  ) =>
      callback(navigatorKey, store, action, next);
}

/// A specialized [MiddlewareClass] in [Navigator] controls
/// which uses internally.
class _TypedNavigatorMiddleware<S, T> implements MiddlewareClass<S> {
  const _TypedNavigatorMiddleware({
    @required this.navigatorKey,
    @required this.callback,
  })  : assert(navigatorKey != null),
        assert(callback != null);

  final GlobalKey<NavigatorState> navigatorKey;
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

/// Returns list of [Navigator] controls related [Middleware].
List<Middleware<S>> navigatorMiddleware<S>(
  /// The [GlobalKey] for [Navigator] that you use. You need to set
  /// the same [GlobalKey] for here and [MaterialApp] or [Navigator] that
  /// you use.
  GlobalKey<NavigatorState> navigatorKey, {

  /// A list of custom [NavigatorMiddlewareCallback].
  ///
  /// You can add more behavior by giving list of custom
  /// [NavigatorMiddlewareCallback]. If you specify no callbacks, only
  /// [basicNavigatorCallbacks] will be used by default.
  List<NavigatorMiddlewareCallback<S, dynamic>> customCallbacks = const [],
}) {
  assert(customCallbacks != null);

  final callbacks = basicNavigatorCallbacks<S>()..addAll(customCallbacks);
  return [
    ...callbacks.map(
      (callback) => _TypedNavigatorMiddleware<S, dynamic>(
        navigatorKey: navigatorKey,
        callback: callback,
      ),
    ),
  ];
}
