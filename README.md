# redux_navigator

A [Redux](https://pub.dartlang.org/packages/redux) middleware for Navigator of Flutter & utils to add custom behavior of Navigator controls.

This package is built to work with [Redux.dart](https://pub.dartlang.org/packages/redux) 3.0.0+.

## navigatorMiddleware

  * `navigatorMiddleware` - A function that returns bundle of Navigator related middleware. You can also add more custom middleware by using `NavigatorMiddlewareCallback`.
  * `NavigatorMiddlewareBuilder` - A builder class for navigatorMiddleware. You can define custom behaviors with it.

## Dart Version
  * Dart 2.2.3+

## Usage

Demonstrate how to use `redux_navigator`.

  1. How to use default `navigatorMiddleware`.
  2. How to add custom behaviors with `NavigatorMiddlewareBuilder`. 

### How to use default list of Navigator related middleware.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_navigator/redux_navigator.dart';

class AppState {}

AppState appReducer(AppState state, dynamic action) {
  return state;
}

void main() {
  /// Initialize navigatorKey which is used for passing to
  /// [navigatorMiddleware] & [MaterialApp].
  final navigatorKey = GlobalKey<NavigatorState>();

  runApp(
    StoreProvider<AppState>(
      store: Store<AppState>(
        appReducer,
        initialState: AppState(),
        middleware: [
          /// Add navigatorMiddleware to middleware with [navigatorKey].
          ...navigatorMiddleware<AppState>(navigatorKey),
        ],
      ),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        /// Pass navigatorKey to [MaterialApp].
        navigatorKey: navigatorKey,
        home: const HomePage(),
      ),
    ),
  );
}

/// A page which presents list of infinity indexes.
class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Get Store by using StoreProvider. The store will be used dispatching
    /// Navigator Action.
    final store = StoreProvider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('redux_heaven_demo'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => InkWell(
          /// Dispatch PushAction to navigate DetailPage.
          ///
          /// You can also use PushNamedAction with routeName parameter.
          onTap: () => store.dispatch(
            PushAction(
              MaterialPageRoute<void>(
                builder: (context) => DetailPage(index: index),
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Item: $index',
                  style: Theme.of(context).textTheme.button,
                ),
                const Icon(Icons.navigate_next)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Destination of [PushAction] above.
class DetailPage extends StatelessWidget {
  const DetailPage({
    @required this.index,
    Key key,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Detail Page : $index'),
      ),
      body: Center(
        child: Text(
          'Item:$index',
          style: Theme.of(context).textTheme.title,
        ),
      ),
    );
  }
}

```

2. How to define custom behaviors. 

```dart
navigatorMiddleware<AppState>(
  navigatorKey,
  customBuilders: [
    /// You can add custom [Navigator] related behaviors by
    /// specifying [NavigatorMiddlewareBuilder]s list.
    NavigatorMiddlewareBuilder<AppState, ShowAlertDialogAction>(
      callback: (navigatorKey, store, action, next) {
        showDialog<void>(
          context: navigatorKey.currentState.overlay.context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Addtional Middleware'),
            );
          },
        );
      },
    ),
  ],
),
```