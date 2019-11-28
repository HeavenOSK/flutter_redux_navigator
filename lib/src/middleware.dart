import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import 'actions.dart';

typedef TypedMiddlewareCallback<State, Action> = void Function(
  Store<State> store,
  Action action,
  NextDispatcher next,
);

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
    TypedMiddleware<dynamic, PopAndPushNamedAction>(
      _handlePopAndPushNamedAction(key),
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

TypedMiddlewareCallback<dynamic, PushAction> _handlePushAction(
    GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) => navigatorKey.currentState.push<void>(action.route);
}

TypedMiddlewareCallback<dynamic, PushNamedAction> _handlePushNamedRoute(
    GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) => navigatorKey.currentState
      .pushNamed(action.routeName, arguments: action.arguments);
}

TypedMiddlewareCallback<dynamic, PushReplacementAction>
    _handlePushReplacementAction(GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) =>
      navigatorKey.currentState.pushReplacement<void, void>(action.route);
}

TypedMiddlewareCallback<dynamic, PushReplacementNamedAction>
    _handlePushReplacementNamedAction(GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) => navigatorKey.currentState
      .pushReplacementNamed(action.routeName, arguments: action.arguments);
}

TypedMiddlewareCallback<dynamic, PopAndPushNamedAction>
    _handlePopAndPushNamedAction(GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) => navigatorKey.currentState
      .popAndPushNamed(action.routeName, arguments: action.arguments);
}

TypedMiddlewareCallback<dynamic, PushAndRemoveUntilAction>
    _handlePushAndRemoveUntilAction(GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) => navigatorKey.currentState
      .pushAndRemoveUntil<void>(action.route, action.predicate);
}

TypedMiddlewareCallback<dynamic, PushNamedAndRemoveUntilAction>
    _handlePushNamedAndRemoveUntilAction(
        GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) => navigatorKey.currentState.pushNamedAndRemoveUntil(
        action.routeName,
        action.predicate,
        arguments: action.arguments,
      );
}

TypedMiddlewareCallback<dynamic, PopAction> _handlePopAction(
    GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) => navigatorKey.currentState.pop();
}

TypedMiddlewareCallback<dynamic, MaybePopAction> _handleMaybePopAction(
    GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) => navigatorKey.currentState.maybePop();
}

TypedMiddlewareCallback<dynamic, PopUntilAction> _handlePopUntilAction(
    GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) =>
      navigatorKey.currentState.popUntil(action.predicate);
}

TypedMiddlewareCallback<dynamic, ShowDialogAction> _handleShowDialogAction(
    GlobalKey<NavigatorState> navigatorKey) {
  return (_, action, __) => showDialog<void>(
        context: navigatorKey.currentState.overlay.context,
        barrierDismissible: action.barrierDismissible,
        builder: action.builder,
      );
}
