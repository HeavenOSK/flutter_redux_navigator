import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import 'actions.dart';

/// A callback which is executed when type of action defined [T] matched.
///
class NavigatorMiddlewareCallback<S, T> {
  const NavigatorMiddlewareCallback({
    @required this.callback,
  });

  final void Function(
    GlobalKey<NavigatorState> navigatorKey,
    Store<S> store,
    T action,
    NextDispatcher next,
  ) callback;

  void call(
    GlobalKey<NavigatorState> navigatorKey,
    Store<S> store,
    T action,
    NextDispatcher next,
  ) =>
      callback(navigatorKey, store, action, next);
}

class _TypedNavigatorMiddleware<S, T> implements MiddlewareClass<S> {
  const _TypedNavigatorMiddleware({
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
List<Middleware<S>> navigatorMiddleware<S>(
  /// The [GlobalKey] for [Navigator] that you use. You need to set
  /// the same [GlobalKey] for here and [MaterialApp] or [Navigator] that
  /// you use.
  GlobalKey<NavigatorState> navigatorKey, {
  List<NavigatorMiddlewareCallback<S, dynamic>> customNavigatorCallbacks =
      const [],
}) {
  assert(customNavigatorCallbacks != null);
  return [
    _TypedNavigatorMiddleware<S, PushAction>(
      navigatorKey: navigatorKey,
      callback: NavigatorMiddlewareCallback<S, PushAction>(
        callback: (key, state, action, next) =>
            key.currentState.push<void>(action.route),
      ),
    ),
    _TypedNavigatorMiddleware<S, PushNamedAction>(
      navigatorKey: navigatorKey,
      callback: NavigatorMiddlewareCallback<S, PushNamedAction>(
        callback: (key, state, action, next) => key.currentState.pushNamed(
          action.routeName,
          arguments: action.arguments,
        ),
      ),
    ),
    _TypedNavigatorMiddleware<S, PushReplacementAction>(
      navigatorKey: navigatorKey,
      callback: NavigatorMiddlewareCallback<S, PushReplacementAction>(
        callback: (key, state, action, next) =>
            key.currentState.pushReplacement<void, void>(action.route),
      ),
    ),
    _TypedNavigatorMiddleware<S, PushReplacementNamedAction>(
      navigatorKey: navigatorKey,
      callback: NavigatorMiddlewareCallback<S, PushReplacementNamedAction>(
        callback: (key, state, action, next) =>
            key.currentState.pushReplacementNamed(
          action.routeName,
          arguments: action.arguments,
        ),
      ),
    ),
    _TypedNavigatorMiddleware<S, PopAndPushNamedAction>(
      navigatorKey: navigatorKey,
      callback: NavigatorMiddlewareCallback<S, PopAndPushNamedAction>(
        callback: (key, state, action, next) =>
            key.currentState.popAndPushNamed(
          action.routeName,
          arguments: action.arguments,
        ),
      ),
    ),
    _TypedNavigatorMiddleware<S, PushAndRemoveUntilAction>(
      navigatorKey: navigatorKey,
      callback: NavigatorMiddlewareCallback<S, PushAndRemoveUntilAction>(
        callback: (key, state, action, next) =>
            key.currentState.pushAndRemoveUntil<void>(
          action.route,
          action.predicate,
        ),
      ),
    ),
    _TypedNavigatorMiddleware<S, PushNamedAndRemoveUntilAction>(
      navigatorKey: navigatorKey,
      callback: NavigatorMiddlewareCallback<S, PushNamedAndRemoveUntilAction>(
        callback: (key, state, action, next) =>
            key.currentState.pushNamedAndRemoveUntil(
          action.routeName,
          action.predicate,
          arguments: action.arguments,
        ),
      ),
    ),
    _TypedNavigatorMiddleware<S, PopAction>(
      navigatorKey: navigatorKey,
      callback: NavigatorMiddlewareCallback<S, PopAction>(
        callback: (key, state, action, next) => key.currentState.pop(),
      ),
    ),
    _TypedNavigatorMiddleware<S, MaybePopAction>(
      navigatorKey: navigatorKey,
      callback: NavigatorMiddlewareCallback<S, MaybePopAction>(
        callback: (key, state, action, next) => key.currentState.maybePop(),
      ),
    ),
    _TypedNavigatorMiddleware<S, PopUntilAction>(
      navigatorKey: navigatorKey,
      callback: NavigatorMiddlewareCallback<S, PopUntilAction>(
        callback: (key, state, action, next) => key.currentState.popUntil(
          action.predicate,
        ),
      ),
    ),
    _TypedNavigatorMiddleware<S, ShowDialogAction>(
      navigatorKey: navigatorKey,
      callback: NavigatorMiddlewareCallback<S, ShowDialogAction>(
        callback: (key, state, action, next) => showDialog<void>(
          context: key.currentState.overlay.context,
          barrierDismissible: action.barrierDismissible,
          builder: action.builder,
        ),
      ),
    ),
    ...customNavigatorCallbacks.map(
      (callback) => _TypedNavigatorMiddleware<S, dynamic>(
        navigatorKey: navigatorKey,
        callback: callback,
      ),
    ),
  ];
}
