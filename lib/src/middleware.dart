import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

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

class NavigatorMiddleware<S> {
  const NavigatorMiddleware(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  List<Middleware<S>> call({
    List<NavigatorMiddlewareCallback<S, dynamic>> callbacks = const [],
  }) {
    assert(callbacks != null);
    return [
      ...callbacks.map(
        (callback) => _TypedNavigatorMiddleware<S, dynamic>(
          navigatorKey: navigatorKey,
          callback: callback,
        ),
      ),
    ];
  }
}
