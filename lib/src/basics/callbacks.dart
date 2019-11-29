import 'package:flutter/material.dart';

import '../middleware.dart';
import 'actions.dart';

List<NavigatorMiddlewareCallback<S, dynamic>> basicNavigatorCallbacks<S>() {
  return [
    NavigatorMiddlewareCallback<S, PushAction>(
      callback: (key, state, action, next) =>
          key.currentState.push<void>(action.route),
    ),
    NavigatorMiddlewareCallback<S, PushNamedAction>(
      callback: (key, state, action, next) => key.currentState.pushNamed(
        action.routeName,
        arguments: action.arguments,
      ),
    ),
    NavigatorMiddlewareCallback<S, PushReplacementAction>(
      callback: (key, state, action, next) =>
          key.currentState.pushReplacement<void, void>(action.route),
    ),
    NavigatorMiddlewareCallback<S, PushReplacementNamedAction>(
      callback: (key, state, action, next) =>
          key.currentState.pushReplacementNamed(
        action.routeName,
        arguments: action.arguments,
      ),
    ),
    NavigatorMiddlewareCallback<S, PopAndPushNamedAction>(
      callback: (key, state, action, next) => key.currentState.popAndPushNamed(
        action.routeName,
        arguments: action.arguments,
      ),
    ),
    NavigatorMiddlewareCallback<S, PushAndRemoveUntilAction>(
      callback: (key, state, action, next) =>
          key.currentState.pushAndRemoveUntil<void>(
        action.route,
        action.predicate,
      ),
    ),
    NavigatorMiddlewareCallback<S, PushNamedAndRemoveUntilAction>(
      callback: (key, state, action, next) =>
          key.currentState.pushNamedAndRemoveUntil(
        action.routeName,
        action.predicate,
        arguments: action.arguments,
      ),
    ),
    NavigatorMiddlewareCallback<S, PopAction>(
      callback: (key, state, action, next) => key.currentState.pop(),
    ),
    NavigatorMiddlewareCallback<S, MaybePopAction>(
      callback: (key, state, action, next) => key.currentState.maybePop(),
    ),
    NavigatorMiddlewareCallback<S, PopUntilAction>(
      callback: (key, state, action, next) => key.currentState.popUntil(
        action.predicate,
      ),
    ),
    NavigatorMiddlewareCallback<S, ShowDialogAction>(
      callback: (key, state, action, next) => showDialog<void>(
        context: key.currentState.overlay.context,
        barrierDismissible: action.barrierDismissible,
        builder: action.builder,
      ),
    ),
  ];
}
