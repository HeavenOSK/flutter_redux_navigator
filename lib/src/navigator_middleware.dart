import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_heaven/redux_heaven.dart';

import 'basics/basics.dart';

/// A callback for [NavigatorMiddlewareBuilder].
typedef NavigatorMiddlewareCallback<S, T> = void Function(
  GlobalKey<NavigatorState> navigatorKey,
  Store<S> store,
  T action,
  NextDispatcher next,
);

/// A builder of middleware for [Navigator] controls.
///
/// You can define custom behaviors for [navigatorMiddleware] with it.
///
/// Example:
///
/// navigatorMiddleware<AppState>(
///    navigatorKey,
///    customBuilders: [
///      NavigatorMiddlewareBuilder<AppState, ShowAlertDialogAction>(
///        callback: (navigatorKey, store, action, next) {
///          showDialog<void>(
///            context: navigatorKey.currentState.overlay.context,
///            builder: (context) {
///              return const AlertDialog(
///                content: Text('Addtional Middleware'),
///              );
///            },
///          );
///        },
///      ),
///    ],
///  ),
///
class NavigatorMiddlewareBuilder<S, T>
    extends InjectableMiddlewareBuilder<S, T, GlobalKey<NavigatorState>> {
  const NavigatorMiddlewareBuilder({
    @required NavigatorMiddlewareCallback<S, T> callback,
  })  : assert(callback != null),
        super(callback: callback);
}

/// Returns list of [Navigator] controls related [Middleware].
Iterable<Middleware<S>> navigatorMiddleware<S>(
  /// The [GlobalKey] for [Navigator] that you use. You need to set
  /// the same [GlobalKey] for here and [MaterialApp] or [Navigator] that
  /// you use.
  GlobalKey<NavigatorState> navigatorKey, {

  /// A list of custom [NavigatorMiddlewareBuilder].
  ///
  /// You can add more behavior by giving list of custom
  /// [NavigatorMiddlewareBuilder]. If you specify no customBuilders,
  /// this method represents basic navigator related middleware.
  List<NavigatorMiddlewareBuilder<S, dynamic>> customBuilders = const [],
}) {
  assert(customBuilders != null);
  return InjectableMiddleware<S, GlobalKey<NavigatorState>>(
    builders: [
      ...basicNavigatorBuilders<S>(),
      ...customBuilders,
    ],
  )(navigatorKey);
}
