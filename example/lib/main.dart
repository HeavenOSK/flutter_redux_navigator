import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_navigator/redux_navigator.dart';

class AppState {}

AppState appReducer(AppState state, dynamic action) {
  return state;
}

void main() {
  /// Important thing: You should set the same navigatorKey
  /// to MaterialApp & below navigatorMiddleware.
  final navigatorKey = GlobalKey<NavigatorState>();

  runApp(
    StoreProvider<AppState>(
      store: Store<AppState>(
        appReducer,
        initialState: AppState(),
        middleware: [
          LoggingMiddleware<AppState>.printer(),

          /// Important thing: You should set the same navigatorKey
          /// here & MaterialApp below .
          ...navigatorMiddleware<AppState>(navigatorKey),
        ],
      ),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        /// Important thing: You should set the same navigatorKey
        /// here & navigatorMiddleware above.
        navigatorKey: navigatorKey,
        home: const HomePage(),
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('redux_heaven_demo'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => InkWell(
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
