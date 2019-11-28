import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import 'actions.dart';

typedef NavigatorMiddlewareCallback<State, Action> = void Function(
  GlobalKey<NavigatorState> navigatorKey,
  Store<State> store,
  Action action,
  NextDispatcher next,
);

class NavigatorMiddleware<State, Action> implements MiddlewareClass<State> {
  const NavigatorMiddleware({
    @required this.key,
    @required this.callback,
  });

  final GlobalKey<NavigatorState> key;
  final NavigatorMiddlewareCallback<State, Action> callback;

  @override
  void call(Store<State> store, dynamic action, NextDispatcher next) {
    if (action is Action) {
      callback(key, store, action, next);
    } else {
      next(action);
    }
  }
}

typedef NavigatorMiddlewareCreator<State, Action>
    = NavigatorMiddleware<State, Action> Function(
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
List<Middleware<dynamic>> navigatorMiddleware(
  /// The [GlobalKey] for [Navigator] that you use. You need to set
  /// the same [GlobalKey] for here and [MaterialApp] or [Navigator] that
  /// you use.
  GlobalKey<NavigatorState> key, {

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
  List<NavigatorMiddlewareCreator> navigatorMiddlewareCreators,
}) {
  return [
    NavigatorMiddleware<dynamic, PushAction>(
      key: key,
      callback: (key, state, action, next) {
        key.currentState.push<void>(action.route);
      },
    ),
    NavigatorMiddleware<dynamic, PushNamedAction>(
      key: key,
      callback: (key, state, action, next) {
        key.currentState
            .pushNamed(action.routeName, arguments: action.arguments);
      },
    ),
    NavigatorMiddleware<dynamic, PushReplacementAction>(
      key: key,
      callback: (key, state, action, next) {
        key.currentState.pushReplacement<void, void>(action.route);
      },
    ),
    NavigatorMiddleware<dynamic, PushReplacementNamedAction>(
      key: key,
      callback: (key, state, action, next) {
        key.currentState.pushReplacementNamed(action.routeName,
            arguments: action.arguments);
      },
    ),
    NavigatorMiddleware<dynamic, PopAndPushNamedAction>(
      key: key,
      callback: (key, state, action, next) {
        key.currentState
            .popAndPushNamed(action.routeName, arguments: action.arguments);
      },
    ),
    NavigatorMiddleware<dynamic, PushAndRemoveUntilAction>(
      key: key,
      callback: (key, state, action, next) {
        key.currentState
            .pushAndRemoveUntil<void>(action.route, action.predicate);
      },
    ),
    NavigatorMiddleware<dynamic, PushNamedAndRemoveUntilAction>(
      key: key,
      callback: (key, state, action, next) {
        key.currentState.pushNamedAndRemoveUntil(
          action.routeName,
          action.predicate,
          arguments: action.arguments,
        );
      },
    ),
    NavigatorMiddleware<dynamic, PopAction>(
      key: key,
      callback: (key, state, action, next) {
        key.currentState.pop();
      },
    ),
    NavigatorMiddleware<dynamic, MaybePopAction>(
      key: key,
      callback: (key, state, action, next) {
        key.currentState.maybePop();
      },
    ),
    NavigatorMiddleware<dynamic, PopUntilAction>(
      key: key,
      callback: (key, state, action, next) {
        key.currentState.popUntil(action.predicate);
      },
    ),
    NavigatorMiddleware<dynamic, ShowDialogAction>(
      key: key,
      callback: (key, state, action, next) {
        showDialog<void>(
          context: key.currentState.overlay.context,
          barrierDismissible: action.barrierDismissible,
          builder: action.builder,
        );
      },
    ),
    ...navigatorMiddlewareCreators.map((creator) => creator(key)),
  ];
}
