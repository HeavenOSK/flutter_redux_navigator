import 'package:flutter/material.dart';

/// An action to call [Navigator.push].
class PushAction {
  const PushAction(this.route);

  /// A route to pass [Navigator.push] method.
  final Route route;
}

/// An action to call [Navigator.pushNamed].
class PushNamedAction {
  const PushNamedAction(
    this.routeName, {
    this.arguments,
  });

  /// A route to pass [Navigator.pushNamed] method.
  final String routeName;

  /// Arguments to pass [Navigator.pushNamed] method.
  final Object arguments;

  @override
  String toString() => 'PushNamedAction('
      'routeName:$routeName'
      ')';
}

/// An action to call [Navigator.pushReplacement].
class PushReplacementAction {
  const PushReplacementAction(this.route);

  /// A route to pass [Navigator.pushReplacement] method.
  final Route route;
}

/// An action to call [Navigator.pushReplacementNamed].
class PushReplacementNamedAction {
  const PushReplacementNamedAction(
    this.routeName, {
    this.arguments,
  });

  /// A routeName to pass [Navigator.pushReplacementNamed] method.
  final String routeName;

  /// Arguments to pass [Navigator.pushReplacementNamed] method.
  final Object arguments;

  @override
  String toString() => 'PushReplacementNamedAction('
      'routeName:$routeName'
      ')';
}

/// An action to call [Navigator.popAndPushNamed].
class PopAndPushNamedAction {
  const PopAndPushNamedAction(
    this.routeName, {
    this.arguments,
  });

  /// A routeName to pass [Navigator.popAndPushNamed] method.
  final String routeName;

  /// Arguments to pass [Navigator.popAndPushNamed] method.
  final Object arguments;

  @override
  String toString() => 'PopAndPushNamedAction('
      'routeName:$routeName'
      ')';
}

/// An action to call [Navigator.pushAndRemoveUntil].
class PushAndRemoveUntilAction {
  const PushAndRemoveUntilAction(this.route, this.predicate);

  /// A route to pass [Navigator.pushAndRemoveUntil] method.
  final Route route;

  /// A predicate to pass [Navigator.pushAndRemoveUntil] method.
  final RoutePredicate predicate;
}

/// An action to call [Navigator.pushNamedAndRemoveUntil].
class PushNamedAndRemoveUntilAction {
  const PushNamedAndRemoveUntilAction(
    this.routeName,
    this.predicate, {
    this.arguments,
  });

  /// A routeName to pass [Navigator.pushNamedAndRemoveUntil] method.
  final String routeName;

  /// A predicate to pass [Navigator.pushNamedAndRemoveUntil] method.
  final RoutePredicate predicate;

  /// Arguments to pass [Navigator.pushNamedAndRemoveUntil] method.
  final Object arguments;

  @override
  String toString() => 'PushNamedAndRemoveUntilAction('
      'routeName:$routeName'
      ')';
}

/// An action to call [Navigator.pop].
class PopAction {
  const PopAction();
}

/// An action to call [Navigator.maybePop].
class MaybePopAction {
  const MaybePopAction();
}

/// An action to call [Navigator.popUntil].
class PopUntilAction {
  const PopUntilAction(this.predicate);

  /// A predicate to pass [Navigator.popUntil] method.
  final RoutePredicate predicate;
}

/// An action to call [showDialog].
class ShowDialogAction {
  const ShowDialogAction({
    @required this.builder,
    this.barrierDismissible = true,
  });

  /// A builder to pass [showDialog] method.
  final WidgetBuilder builder;

  /// A barrierDismissible to pass [showDialog] method.
  final bool barrierDismissible;
}
