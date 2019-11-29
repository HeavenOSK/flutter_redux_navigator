import 'package:flutter/material.dart';
import 'package:redux_navigator/src/middleware.dart';

import 'actions.dart';

/// Returns list of basic callbacks to use [Navigator] methods.
List<NavigatorMiddlewareBuilder<S, dynamic>> basicNavigatorCreator<S>() {
  return [
    NavigatorMiddlewareBuilder<S, PushAction>(
      callback: (key, state, action, next) {
        key.currentState.push<void>(action.route);
      },
    ),
    NavigatorMiddlewareBuilder<S, PushNamedAction>(
      callback: (key, state, action, next) {
        key.currentState.pushNamed(
          action.routeName,
          arguments: action.arguments,
        );
      },
    ),
    NavigatorMiddlewareBuilder<S, PushReplacementAction>(
      callback: (key, state, action, next) {
        key.currentState.pushReplacement<void, void>(action.route);
      },
    ),
    NavigatorMiddlewareBuilder<S, PushReplacementNamedAction>(
      callback: (key, state, action, next) {
        key.currentState.pushReplacementNamed(
          action.routeName,
          arguments: action.arguments,
        );
      },
    ),
    NavigatorMiddlewareBuilder<S, PopAndPushNamedAction>(
      callback: (key, state, action, next) {
        key.currentState.popAndPushNamed(
          action.routeName,
          arguments: action.arguments,
        );
      },
    ),
    NavigatorMiddlewareBuilder<S, PushAndRemoveUntilAction>(
      callback: (key, state, action, next) {
        key.currentState.pushAndRemoveUntil<void>(
          action.route,
          action.predicate,
        );
      },
    ),
    NavigatorMiddlewareBuilder<S, PushNamedAndRemoveUntilAction>(
      callback: (key, state, action, next) {
        key.currentState.pushNamedAndRemoveUntil(
          action.routeName,
          action.predicate,
          arguments: action.arguments,
        );
      },
    ),
    NavigatorMiddlewareBuilder<S, PopAction>(
      callback: (key, state, action, next) {
        key.currentState.pop();
      },
    ),
    NavigatorMiddlewareBuilder<S, MaybePopAction>(
      callback: (key, state, action, next) {
        key.currentState.maybePop();
      },
    ),
    NavigatorMiddlewareBuilder<S, PopUntilAction>(
      callback: (key, state, action, next) => key.currentState.popUntil(
        action.predicate,
      ),
    ),
    NavigatorMiddlewareBuilder<S, ShowDialogAction>(
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
