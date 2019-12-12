import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';

/// A callback for [_TypedInjectableMiddleware].
typedef InjectableMiddlewareCallback<S, T, O> = void Function(
  O dependency,
  Store<S> store,
  T action,
  NextDispatcher next,
);

/// A type matching middleware which is able to be injected dependency..
class _TypedInjectableMiddleware<S, T, O> implements MiddlewareClass<S> {
  const _TypedInjectableMiddleware({
    @required this.dependency,
    @required this.callback,
  })  : assert(dependency != null),
        assert(callback != null);

  /// Any dependency.
  final O dependency;

  /// A callback for middleware with dependency.
  final InjectableMiddlewareCallback<S, T, O> callback;

  /// Executes [callback] if tha type of [action] is matched.
  @override
  void call(Store<S> store, dynamic action, NextDispatcher next) {
    if (action is T) {
      callback(dependency, store, action, next);
    } else {
      next(action);
    }
  }
}

/// A builder for [InjectableMiddleware].
abstract class InjectableMiddlewareBuilder<S, T, O> {
  const InjectableMiddlewareBuilder({
    @required this.callback,
  }) : assert(callback != null);

  /// A callback for [_TypedInjectableMiddleware].
  @protected
  final InjectableMiddlewareCallback<S, T, O> callback;

  /// Builds middleware with [dependency].
  @mustCallSuper
  @protected
  _TypedInjectableMiddleware<S, T, O> build(O dependency) {
    return _TypedInjectableMiddleware(
      dependency: dependency,
      callback: callback,
    );
  }
}

/// A middleware which is able to be injected dependency.
class InjectableMiddleware<S, O> {
  const InjectableMiddleware({
    @required this.builders,
  }) : assert(builders != null);

  /// A collection of [InjectableMiddlewareBuilder]s.
  final Iterable<InjectableMiddlewareBuilder<S, dynamic, O>> builders;

  /// Generates middleware with a [dependency]..
  Iterable<Middleware<S>> call(O dependency) {
    assert(dependency != null);
    return [
      ...builders.map(
        (builder) => builder.build(dependency),
      ),
    ];
  }
}
