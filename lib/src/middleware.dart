import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import 'actions.dart';

typedef NavigatorMiddlewareCallback<S, T> = void Function(
  GlobalKey<NavigatorState> navigatorKey,
  Store<S> store,
  T action,
  NextDispatcher next,
);

class TypedNavigatorMiddleware<S, T> implements MiddlewareClass<S> {
  const TypedNavigatorMiddleware({
    @required this.key,
    @required this.callback,
  });

  final GlobalKey<NavigatorState> key;
  final NavigatorMiddlewareCallback<S, T> callback;

  @override
  void call(Store<S> store, dynamic action, NextDispatcher next) {
    if (action is T) {
      callback(key, store, action, next);
    } else {
      next(action);
    }
  }
}

typedef TypedNavigatorMiddlewareCreator<S, T> = TypedNavigatorMiddleware<S, T>
    Function(
  GlobalKey<NavigatorState> navigatorKey,
);

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

  /// A list of custom [Middleware].
  ///
  /// You can add extra [Middleware] which related [Navigator]'s controls here.
  ///
  /// ### Example
  /// final store = Store<AppState>(
  ///   appReducer,
  ///   initialState: AppState(),
  ///   middleware: [
  ///     ...navigatorMiddleware(
  ///       navigatorKey,
  ///       customMiddleware: [
  ///         animatedDialogMiddleware,
  ///       ],
  ///     ),
  ///   ],
  /// );
  ///
  List<TypedNavigatorMiddlewareCreator<S, dynamic>> navigatorMiddlewareCreators,
}) {
  return [
    TypedNavigatorMiddleware<S, PushAction>(
      key: navigatorKey,
      callback: (key, state, action, next) =>
          key.currentState.push<void>(action.route),
    ),
    TypedNavigatorMiddleware<S, PushNamedAction>(
      key: navigatorKey,
      callback: (key, state, action, next) => key.currentState.pushNamed(
        action.routeName,
        arguments: action.arguments,
      ),
    ),
    TypedNavigatorMiddleware<S, PushReplacementAction>(
      key: navigatorKey,
      callback: (key, state, action, next) =>
          key.currentState.pushReplacement<void, void>(action.route),
    ),
    TypedNavigatorMiddleware<S, PushReplacementNamedAction>(
      key: navigatorKey,
      callback: (key, state, action, next) =>
          key.currentState.pushReplacementNamed(
        action.routeName,
        arguments: action.arguments,
      ),
    ),
    TypedNavigatorMiddleware<S, PopAndPushNamedAction>(
      key: navigatorKey,
      callback: (key, state, action, next) => key.currentState.popAndPushNamed(
        action.routeName,
        arguments: action.arguments,
      ),
    ),
    TypedNavigatorMiddleware<S, PushAndRemoveUntilAction>(
      key: navigatorKey,
      callback: (key, state, action, next) =>
          key.currentState.pushAndRemoveUntil<void>(
        action.route,
        action.predicate,
      ),
    ),
    TypedNavigatorMiddleware<S, PushNamedAndRemoveUntilAction>(
      key: navigatorKey,
      callback: (key, state, action, next) =>
          key.currentState.pushNamedAndRemoveUntil(
        action.routeName,
        action.predicate,
        arguments: action.arguments,
      ),
    ),
    TypedNavigatorMiddleware<S, PopAction>(
      key: navigatorKey,
      callback: (key, state, action, next) => key.currentState.pop(),
    ),
    TypedNavigatorMiddleware<S, MaybePopAction>(
      key: navigatorKey,
      callback: (key, state, action, next) => key.currentState.maybePop(),
    ),
    TypedNavigatorMiddleware<S, PopUntilAction>(
      key: navigatorKey,
      callback: (key, state, action, next) => key.currentState.popUntil(
        action.predicate,
      ),
    ),
    TypedNavigatorMiddleware<S, ShowDialogAction>(
      key: navigatorKey,
      callback: (key, state, action, next) => showDialog<void>(
        context: key.currentState.overlay.context,
        barrierDismissible: action.barrierDismissible,
        builder: action.builder,
      ),
    ),
    ...navigatorMiddlewareCreators.map((creator) => creator(navigatorKey)),
  ];
}
