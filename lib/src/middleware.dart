import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import 'actions.dart';

typedef _TypedMiddlewareCallback<State, Action> = void Function(
    Store<State> store, Action action, NextDispatcher next);

typedef NavigatorMiddlewareHandler<State, Action>
    = _TypedMiddlewareCallback<State, Action> Function(
        GlobalKey<NavigatorState> navigatorKey);

List<Middleware<dynamic>> navigatorMiddleware(
  GlobalKey<NavigatorState> key, {
  List<Middleware<dynamic>> customMiddleware = const [],
}) {
  assert(customMiddleware != null);
  return [
    TypedMiddleware<dynamic, PushAction>(
      _handlePushAction(key),
    ),
    TypedMiddleware<dynamic, PushNamedAction>(
      _handlePushNamedRoute(key),
    ),
    TypedMiddleware<dynamic, PushReplacementAction>(
      _handlePushReplacementAction(key),
    ),
    TypedMiddleware<dynamic, PushReplacementNamedAction>(
      _handlePushReplacementNamedAction(key),
    ),
    TypedMiddleware<dynamic, PushAndRemoveUntilAction>(
      _handlePushAndRemoveUntilAction(key),
    ),
    TypedMiddleware<dynamic, PushNamedAndRemoveUntilAction>(
      _handlePushNamedAndRemoveUntilAction(key),
    ),
    TypedMiddleware<dynamic, PopAction>(
      _handlePopAction(key),
    ),
    TypedMiddleware<dynamic, MaybePopAction>(
      _handleMaybePopAction(key),
    ),
    TypedMiddleware<dynamic, PopUntilAction>(
      _handlePopUntilAction(key),
    ),
    TypedMiddleware<dynamic, ShowDialogAction>(
      _handleShowDialogAction(key),
    ),
    ...customMiddleware,
  ];
}

NavigatorMiddlewareHandler<dynamic, PushAction> _handlePushAction =
    (navigatorKey) {
  return (_, action, __) => navigatorKey.currentState.push(action.route);
};

NavigatorMiddlewareHandler<dynamic, PushNamedAction> _handlePushNamedRoute =
    (navigatorKey) {
  return (_, action, __) => navigatorKey.currentState
      .pushNamed(action.routeName, arguments: action.arguments);
};

NavigatorMiddlewareHandler<dynamic, PushReplacementAction>
    _handlePushReplacementAction = (navigatorKey) {
  return (_, action, __) =>
      navigatorKey.currentState.pushReplacement(action.route);
};

NavigatorMiddlewareHandler<dynamic, PushReplacementNamedAction>
    _handlePushReplacementNamedAction = (navigatorKey) {
  return (_, action, __) => navigatorKey.currentState
      .pushReplacementNamed(action.routeName, arguments: action.arguments);
};

NavigatorMiddlewareHandler<dynamic, PushAndRemoveUntilAction>
    _handlePushAndRemoveUntilAction = (navigatorKey) {
  return (_, action, __) => navigatorKey.currentState
      .pushAndRemoveUntil(action.route, action.predicate);
};

NavigatorMiddlewareHandler<dynamic, PushNamedAndRemoveUntilAction>
    _handlePushNamedAndRemoveUntilAction = (navigatorKey) {
  return (_, action, __) => navigatorKey.currentState.pushNamedAndRemoveUntil(
        action.routeName,
        action.predicate,
        arguments: action.arguments,
      );
};

NavigatorMiddlewareHandler<dynamic, PopAction> _handlePopAction =
    (navigatorKey) {
  return (_, action, __) => navigatorKey.currentState.pop();
};

NavigatorMiddlewareHandler<dynamic, MaybePopAction> _handleMaybePopAction =
    (navigatorKey) {
  return (_, action, __) => navigatorKey.currentState.maybePop();
};

NavigatorMiddlewareHandler<dynamic, PopUntilAction> _handlePopUntilAction =
    (navigatorKey) {
  return (_, action, __) =>
      navigatorKey.currentState.popUntil(action.predicate);
};

NavigatorMiddlewareHandler<dynamic, ShowDialogAction> _handleShowDialogAction =
    (navigatorKey) {
  return (_, action, __) => showDialog(
        context: navigatorKey.currentState.overlay.context,
        barrierDismissible: action.barrierDismissible,
        builder: action.builder,
      );
};
