import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import 'actions.dart';

typedef TypedMiddlewareCallback<S, T> = void Function(
  Store<S> store,
  T action,
  NextDispatcher next,
);

typedef NavigatorMiddlewareCallback<S, T> = void Function(
  GlobalKey<NavigatorState> navigatorKey,
  Store<S> store,
  T action,
  NextDispatcher next,
);

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

/// Returns list of simple [Middleware] which related [Navigator]'s controls.
///
/// All the [Middleware] here do only navigation or dialog related things.
///
/// ### Example of how to add navigatorMiddleware.
///
/// final store = Store<AppState>(
///   appReducer,
///   initialState: AppState(),
///   middleware: [
///     ...navigatorMiddleware(navigatorKey),
///   ],
/// );
///
/// ### Example of how to use with [Route].
///
/// store.dispatch(
///   PushAction(
///     MaterialPageRoute<void>(
///       builder: (context) => DetailPage(),
///   ),
/// );
///
/// ### Example of how to use with path.
///
/// store.dispatch(
///   PushNamedAction('/detail/')
/// );
///
List<Middleware<S>> navigatorMiddleware<S>(
  /// The [GlobalKey] for [Navigator] that you use. You need to set
  /// the same [GlobalKey] for here and [MaterialApp] or [Navigator] that
  /// you use.
  GlobalKey<NavigatorState> navigatorKey, {
  List<NavigatorMiddlewareCallback<S, dynamic>> customNavigatorCallback =
      const [],
}) {
  assert(customNavigatorCallback != null);
  return [
    TypedNavigatorMiddleware<S, PushAction>(
      navigatorKey: navigatorKey,
      callback: (key, state, action, next) =>
          key.currentState.push<void>(action.route),
    ),
    TypedNavigatorMiddleware<S, PushNamedAction>(
      navigatorKey: navigatorKey,
      callback: (key, state, action, next) => key.currentState.pushNamed(
        action.routeName,
        arguments: action.arguments,
      ),
    ),
    TypedNavigatorMiddleware<S, PushReplacementAction>(
      navigatorKey: navigatorKey,
      callback: (key, state, action, next) =>
          key.currentState.pushReplacement<void, void>(action.route),
    ),
    TypedNavigatorMiddleware<S, PushReplacementNamedAction>(
      navigatorKey: navigatorKey,
      callback: (key, state, action, next) =>
          key.currentState.pushReplacementNamed(
        action.routeName,
        arguments: action.arguments,
      ),
    ),
    TypedNavigatorMiddleware<S, PopAndPushNamedAction>(
      navigatorKey: navigatorKey,
      callback: (key, state, action, next) => key.currentState.popAndPushNamed(
        action.routeName,
        arguments: action.arguments,
      ),
    ),
    TypedNavigatorMiddleware<S, PushAndRemoveUntilAction>(
      navigatorKey: navigatorKey,
      callback: (key, state, action, next) =>
          key.currentState.pushAndRemoveUntil<void>(
        action.route,
        action.predicate,
      ),
    ),
    TypedNavigatorMiddleware<S, PushNamedAndRemoveUntilAction>(
      navigatorKey: navigatorKey,
      callback: (key, state, action, next) =>
          key.currentState.pushNamedAndRemoveUntil(
        action.routeName,
        action.predicate,
        arguments: action.arguments,
      ),
    ),
    TypedNavigatorMiddleware<S, PopAction>(
      navigatorKey: navigatorKey,
      callback: (key, state, action, next) => key.currentState.pop(),
    ),
    TypedNavigatorMiddleware<S, MaybePopAction>(
      navigatorKey: navigatorKey,
      callback: (key, state, action, next) => key.currentState.maybePop(),
    ),
    TypedNavigatorMiddleware<S, PopUntilAction>(
      navigatorKey: navigatorKey,
      callback: (key, state, action, next) => key.currentState.popUntil(
        action.predicate,
      ),
    ),
    TypedNavigatorMiddleware<S, ShowDialogAction>(
      navigatorKey: navigatorKey,
      callback: (key, state, action, next) => showDialog<void>(
        context: key.currentState.overlay.context,
        barrierDismissible: action.barrierDismissible,
        builder: action.builder,
      ),
    ),
    ...customNavigatorCallback.map(
      (callback) => TypedNavigatorMiddleware<S, dynamic>(
        navigatorKey: navigatorKey,
        callback: callback,
      ),
    ),
  ];
}
