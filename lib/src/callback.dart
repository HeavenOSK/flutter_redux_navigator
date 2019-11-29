import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

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
