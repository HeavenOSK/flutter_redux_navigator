import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

typedef NavigatorMiddlewareCallback<S, T> = void Function(
  GlobalKey<NavigatorState> navigatorKey,
  Store<S> store,
  T action,
  NextDispatcher next,
);

/// A specialized [MiddlewareClass] in [Navigator] controls
/// which uses internally.
class TypedNavigatorMiddleware<S, T> implements MiddlewareClass<S> {
  const TypedNavigatorMiddleware({
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

// ignore: one_member_abstracts
abstract class NavigatorMiddlewareBuilder<S, T> {
  TypedNavigatorMiddleware<S, T> build(GlobalKey<NavigatorState> navigatorKey);
}

/// A callback specialized in [Navigator] related [Middleware]
/// which is executed when type of action defined [T] matched.
///
/// You can add custom behavior to [navigatorMiddleware] using
/// this.
class CallbackNavigatorMiddlewareBuilder<S, T>
    extends NavigatorMiddlewareBuilder<S, T> {
  CallbackNavigatorMiddlewareBuilder({
    @required this.callback,
  }) : assert(callback != null);

  /// a callback which uses [NavigatorState] in middleware.
  final NavigatorMiddlewareCallback<S, T> callback;

  @override
  TypedNavigatorMiddleware<S, T> build(GlobalKey<NavigatorState> navigatorKey) {
    return TypedNavigatorMiddleware<S, T>(
      navigatorKey: navigatorKey,
      callback: callback,
    );
  }
}
