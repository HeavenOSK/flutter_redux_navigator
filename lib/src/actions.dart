import 'package:flutter/widgets.dart';

class PushAction {
  const PushAction(this.route);

  final Route route;
}

class PushNamedAction {
  const PushNamedAction(
    this.routeName, {
    this.arguments,
  });

  final String routeName;
  final Object arguments;
}

class PushReplacementAction {
  const PushReplacementAction(this.route);

  final Route route;
}

class PushReplacementNamedAction {
  const PushReplacementNamedAction(
    this.routeName, {
    this.arguments,
  });

  final String routeName;
  final Object arguments;
}

class PopAndPushNamedAction {
  const PopAndPushNamedAction(
    this.routeName, {
    this.arguments,
  });

  final String routeName;
  final Object arguments;
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
  ShowDialogAction({
    @required this.builder,
    this.barrierDismissible = true,
  });

  final WidgetBuilder builder;
  final bool barrierDismissible;
}
