import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import 'basics/basics.dart';

/// A callback which is executed when type of action defined [T] matched.
///
class NavigatorMiddlewareCallback<S, T> {
  const NavigatorMiddlewareCallback({
    @required this.callback,
  });

  final void Function(
    GlobalKey<NavigatorState> navigatorKey,
    Store<S> store,
    T action,
    NextDispatcher next,
  ) callback;

  void call(
    GlobalKey<NavigatorState> navigatorKey,
    Store<S> store,
    T action,
    NextDispatcher next,
  ) =>
      callback(navigatorKey, store, action, next);
}

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

List<Middleware<S>> navigatorMiddleware<S>(
  GlobalKey<NavigatorState> navigatorKey, {
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
