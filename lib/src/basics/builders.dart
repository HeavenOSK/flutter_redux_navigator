import 'package:flutter/material.dart';
import 'package:redux_navigator/src/middleware.dart';

import 'actions.dart';

/// Returns list of basic callbacks to use [Navigator] methods.
Iterable<NavigatorMiddlewareBuilder<S, dynamic>> basicNavigatorBuilders<S>() {
  return [
    CallbackNavigatorMiddlewareBuilder<S, PushAction>(
      callback: (key, state, action, next) {
        key.currentState.push<void>(action.route);
      },
    ),
    CallbackNavigatorMiddlewareBuilder<S, PushNamedAction>(
      callback: (key, state, action, next) {
        key.currentState.pushNamed(
          action.routeName,
          arguments: action.arguments,
        );
      },
    ),
    CallbackNavigatorMiddlewareBuilder<S, PushReplacementAction>(
      callback: (key, state, action, next) {
        key.currentState.pushReplacement<void, void>(action.route);
      },
    ),
    CallbackNavigatorMiddlewareBuilder<S, PushReplacementNamedAction>(
      callback: (key, state, action, next) {
        key.currentState.pushReplacementNamed(
          action.routeName,
          arguments: action.arguments,
        );
      },
    ),
    CallbackNavigatorMiddlewareBuilder<S, PopAndPushNamedAction>(
      callback: (key, state, action, next) {
        key.currentState.popAndPushNamed(
          action.routeName,
          arguments: action.arguments,
        );
      },
    ),
    CallbackNavigatorMiddlewareBuilder<S, PushAndRemoveUntilAction>(
      callback: (key, state, action, next) {
        key.currentState.pushAndRemoveUntil<void>(
          action.route,
          action.predicate,
        );
      },
    ),
    CallbackNavigatorMiddlewareBuilder<S, PushNamedAndRemoveUntilAction>(
      callback: (key, state, action, next) {
        key.currentState.pushNamedAndRemoveUntil(
          action.routeName,
          action.predicate,
          arguments: action.arguments,
        );
      },
    ),
    CallbackNavigatorMiddlewareBuilder<S, PopAction>(
      callback: (key, state, action, next) {
        key.currentState.pop();
      },
    ),
    CallbackNavigatorMiddlewareBuilder<S, MaybePopAction>(
      callback: (key, state, action, next) {
        key.currentState.maybePop();
      },
    ),
    CallbackNavigatorMiddlewareBuilder<S, PopUntilAction>(
      callback: (key, state, action, next) => key.currentState.popUntil(
        action.predicate,
      ),
    ),
    CallbackNavigatorMiddlewareBuilder<S, ShowDialogAction>(
      callback: (key, state, action, next) {
        showDialog<void>(
          context: key.currentState.overlay.context,
          barrierDismissible: action.barrierDismissible,
          builder: action.builder,
        );
      },
    ),
  ];
}
