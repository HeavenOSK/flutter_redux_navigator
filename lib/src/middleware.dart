import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import 'actions.dart';

/// A function that uses for argument of [TypedMiddleware].
typedef TypedMiddlewareCallback<State, Action> = void Function(
  Store<State> store,
  Action action,
  NextDispatcher next,
);

/// Returns list of [Navigator] controls related [Middleware].
List<Middleware<S>> navigatorMiddleware<S>(

    /// The [GlobalKey] for [Navigator] that you use. You need to set
    /// the same [GlobalKey] for here and [MaterialApp] or [Navigator] that
    /// you use.
    GlobalKey<NavigatorState> key) {
  return [
    TypedMiddleware<S, PushAction>(
      _handlePushAction<S>(key),
    ),
    TypedMiddleware<S, PushNamedAction>(
      _handlePushNamedRoute<S>(key),
    ),
    TypedMiddleware<S, PushReplacementAction>(
      _handlePushReplacementAction<S>(key),
    ),
    TypedMiddleware<S, PushReplacementNamedAction>(
      _handlePushReplacementNamedAction<S>(key),
    ),
    TypedMiddleware<S, PopAndPushNamedAction>(
      _handlePopAndPushNamedAction<S>(key),
    ),
    TypedMiddleware<S, PushAndRemoveUntilAction>(
      _handlePushAndRemoveUntilAction<S>(key),
    ),
    TypedMiddleware<S, PushNamedAndRemoveUntilAction>(
      _handlePushNamedAndRemoveUntilAction<S>(key),
    ),
    TypedMiddleware<S, PopAction>(
      _handlePopAction<S>(key),
    ),
    TypedMiddleware<S, MaybePopAction>(
      _handleMaybePopAction<S>(key),
    ),
    TypedMiddleware<S, PopUntilAction>(
      _handlePopUntilAction<S>(key),
    ),
    TypedMiddleware<S, ShowDialogAction>(
      _handleShowDialogAction<S>(key),
    ),
  ];
}

TypedMiddlewareCallback<S, PushAction> _handlePushAction<S>(
    GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) => navigatorKey.currentState.push<void>(action.route);
}

TypedMiddlewareCallback<S, PushNamedAction> _handlePushNamedRoute<S>(
    GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) => navigatorKey.currentState
      .pushNamed(action.routeName, arguments: action.arguments);
}

TypedMiddlewareCallback<S, PushReplacementAction>
    _handlePushReplacementAction<S>(GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) =>
      navigatorKey.currentState.pushReplacement<void, void>(action.route);
}

TypedMiddlewareCallback<S, PushReplacementNamedAction>
    _handlePushReplacementNamedAction<S>(
        GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) => navigatorKey.currentState
      .pushReplacementNamed(action.routeName, arguments: action.arguments);
}

TypedMiddlewareCallback<S, PopAndPushNamedAction>
    _handlePopAndPushNamedAction<S>(GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) => navigatorKey.currentState
      .popAndPushNamed(action.routeName, arguments: action.arguments);
}

TypedMiddlewareCallback<S, PushAndRemoveUntilAction>
    _handlePushAndRemoveUntilAction<S>(GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) => navigatorKey.currentState
      .pushAndRemoveUntil<void>(action.route, action.predicate);
}

TypedMiddlewareCallback<S, PushNamedAndRemoveUntilAction>
    _handlePushNamedAndRemoveUntilAction<S>(
        GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) => navigatorKey.currentState.pushNamedAndRemoveUntil(
        action.routeName,
        action.predicate,
        arguments: action.arguments,
      );
}

TypedMiddlewareCallback<S, PopAction> _handlePopAction<S>(
    GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) => navigatorKey.currentState.pop();
}

TypedMiddlewareCallback<S, MaybePopAction> _handleMaybePopAction<S>(
    GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) => navigatorKey.currentState.maybePop();
}

TypedMiddlewareCallback<S, PopUntilAction> _handlePopUntilAction<S>(
    GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) =>
      navigatorKey.currentState.popUntil(action.predicate);
}

TypedMiddlewareCallback<S, ShowDialogAction> _handleShowDialogAction<S>(
    GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) => showDialog<void>(
        context: navigatorKey.currentState.overlay.context,
        barrierDismissible: action.barrierDismissible,
        builder: action.builder,
      );
}
