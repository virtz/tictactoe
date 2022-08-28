import 'package:flutter/material.dart';
import 'package:tictactoe/player.dart';
import 'package:tictactoe/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ///variables 
  final countMatrix = 3;
  final double size = 92;
  String? lastMove;
  List<List<String>>? matrix;
  @override
  void initState() {
    super.initState();
    setEmptyFields();
  }

///create tictacttoe grid
  void setEmptyFields() {
    setState(() {
      matrix = List.generate(
          countMatrix, (_) => List.generate(countMatrix, (_) => Player.none));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: getBackgroundColor(),
        appBar: AppBar(
          title: const Text('Tic Tac Toe',
              style: TextStyle(fontSize: 15.0, color: Colors.white)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: Utils.modelBuilder(matrix!, (x, value) => buildRow(x)),
        ));
  }

  Widget buildRow(int x) {
    final values = matrix![x];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Utils.modelBuilder(values, (y, model) => buildField(x, y)),
    );
  }

  Widget buildField(int x, int y) {
    final value = matrix![x][y];
    final color = getFieldColor(value);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: Size(size, size), primary: color),
          onPressed: () => selectField(value, x, y),
          child: Text(value,
              style: const TextStyle(fontSize: 32, color: Colors.black))),
    );
  }

  void selectField(String value, int x, int y) {
    if (value == Player.none) {
      final newValue = lastMove == Player.X ? Player.O : Player.X;
      setState(() {
        lastMove = newValue;
        matrix![x][y] = newValue;
      });
      if (isWinner(x, y)) {
        showEndDialog('Player $newValue won');
      } else if (isEnd()) {
        showEndDialog('Undecided game');
      }
    }
  }

  bool isEnd() =>
      matrix!.every((values) => values.every((value) => value != Player.none));

  Color getFieldColor(String value) {
    switch (value) {
      case Player.O:
        return Colors.blue;
      case Player.X:
        return Colors.yellow;
      default:
        return Colors.white;
    }
  }

  Color getBackgroundColor() {
    final thisMove = lastMove == Player.X ? Player.O : Player.X;
    return getFieldColor(thisMove).withAlpha(100);
  }

  Future<void> showEndDialog(String title) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: const Text('Press to Restart the Game'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      setEmptyFields();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Restart'))
              ],
            ));
  }


///method to determine winner of gameee
  bool isWinner(int x, int y) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    final player = matrix![x][y];
    final n = countMatrix;

    for (int i = 0; i < n; i++) {
      if (matrix![x][i] == player) col++;
      if (matrix![i][y] == player) row++;
      if (matrix![i][i] == player) diag++;
      if (matrix![i][n - i - 1] == player) rdiag++;
    }

    return row == n || col == n || diag == n || rdiag == n;
  }
}
