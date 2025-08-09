import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 主要启动程序，类似于main()函数
void main() {
  runApp(MyApp());
}

// StatelessWidget?
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      //
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

// ChangeNotifierProvider  这意味着它可以向其他人通知自己的更改。例如，如果当前单词对发生变化，应用中的一些 widget 需要知晓此变化
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    // var?
    current = WordPair.random();
    notifyListeners(); // 通知所有监听者
  }

  // 喜欢功能
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 1.每个 widget 均定义了一个 build() 方法，每当 widget 的环境发生变化时，系统都会自动调用该方法，以便 widget 始终保持最新状态
    // 监听状态变化
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    // 喜欢按钮
    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    //2.MyHomePage 使用 watch 方法跟踪对应用当前状态的更改。
    return Scaffold(
      // 3.每个 build 方法都必须返回一个 widget 或（更常见的）嵌套 widget 树。在本例中，顶层 widget 是 Scaffold。您不会在此 Codelab 中使用 Scaffold，但它是一个有用的 widget。在绝大多数真实的 Flutter 应用中都可以找到该 widget。
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // 4. Column 是 Flutter 中最基础的布局 widget 之一。它接受任意数量的子项并将这些子项从上到下放在一列中。默认情况下，该列会以可视化形式将其子项置于顶部。您很快就会对其进行更改，使该列居中。
          children: [
            // 5.您在第一步中更改了此 Text widget(组件)
            BigCard(pair: pair),
            // sizedbox 用于创建一个具有特定大小的盒子，进阶用法可以渗透至充当margin使用
            const SizedBox(height: 10),
            // 6. 第二个 Text widget 接受 appState，并访问该类的唯一成员 current（这是一个 WordPair）。WordPair 提供了一些有用的 getter，例如 asPascalCase 或 asSnakeCase。此处，我们使用了 asLowerCase。但如果您希望选择其他选项，您现在可以对其进行更改。
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
                // 添加按钮
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // 按钮点击事件  WordPair.random() 生成一个新的随机单词对
                    appState.getNext(); // 调用 getNext 方法以获取下一个单词对
                    print('button click!');
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ], // 7. Column 的 children 属性接受一个 widget 列表。您可以在此处添加任意数量的 widget。您可以使用任何 widget，甚至可以将其他 widget 嵌套在此处。
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;
// 内部样式
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ↓ Add this.
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        // ↓ Change this line.
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

// print有类似debug的作用，输出到控制台
// 这段代码是一个简单的Flutter应用程序，使用了Provider来管理状态
// 有组件内置独立样式，一个class充当一组件
// 唯一缺点就是需要去了解这些组件如何引用
