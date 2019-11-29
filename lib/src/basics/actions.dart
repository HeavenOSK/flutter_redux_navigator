import 'package:flutter/widgets.dart';

/// an action to call [Navigator.push].
class PushAction {
  const PushAction(this.route);

  final Route route;
}

/// an action to call [Navigator.pushNamed].
class PushNamedAction {
  const PushNamedAction(
    this.routeName, {
    this.arguments,
  });

  final String routeName;
  final Object arguments;

  @override
  String toString() => 'PushNamedAction('
      'routeName:$routeName'
      ')';
}

/// an action to call [Navigator.pushReplacement].
class PushReplacementAction {
  const PushReplacementAction(this.route);

  final Route route;
}

/// an action to call [Navigator.pushReplacement].
class PushReplacementNamedAction {
  const PushReplacementNamedAction(
    this.routeName, {
    this.arguments,
  });

  final String routeName;
  final Object arguments;

  @override
  String toString() => 'PushReplacementNamedAction('
      'routeName:$routeName'
      ')';
}

class PopAndPushNamedAction {
  const PopAndPushNamedAction(
    this.routeName, {
    this.arguments,
  });

  final String routeName;
  final Object arguments;

  @override
  String toString() => 'PopAndPushNamedAction('
      'routeName:$routeName'
      ')';
}

class PushAndRemoveUntilAction {
  const PushAndRemoveUntilAction(this.route, this.predicate);

  final Route route;
  final RoutePredicate predicate;
}

class PushNamedAndRemoveUntilAction {
  const PushNamedAndRemoveUntilAction(
    this.routeName,
    this.predicate, {
    this.arguments,
  });

  final String routeName;
  final RoutePredicate predicate;
  final Object arguments;

  @override
  String toString() => 'PushNamedAndRemoveUntilAction('
      'routeName:$routeName'
      ')';
}

class PopAction {
  const PopAction();
}

class MaybePopAction {
  const MaybePopAction();
}

class PopUntilAction {
  const PopUntilAction(this.predicate);

  final RoutePredicate predicate;
}

class ShowDialogAction {
  const ShowDialogAction({
    @required this.builder,
    this.barrierDismissible = true,
  });

  final WidgetBuilder builder;
  final bool barrierDismissible;
}
