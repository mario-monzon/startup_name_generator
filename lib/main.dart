import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

      return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: 'Material App',
      home: RandomWords(),
    );
  }
}


// RandomWordsState
class _RandomWordsState extends State<RandomWords> {

  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _saved = Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    final wordPair = WordPair.random();
    // return Text(wordPair.asPascalCase);

    return Scaffold(
      appBar: AppBar(
        title: Text( 'Startup Name Generator' ),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );

  }


  // _buildSuggestions
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider(); // Divider en index impares

          final index = i ~/ 2;
          if ( index >= _suggestions.length ) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);

        });
  } // _buildSuggestions

  // _buildRow
  Widget _buildRow(WordPair pair) {

    final alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont
      ),
      leading: CircleAvatar(
        child: Icon(
          Icons.person,
          color: Colors.white,
       ),
        backgroundColor: Colors.blueAccent
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red: null,
      ),
      onTap: (){
        setState(() => alreadySaved ? _saved.remove(pair) : _saved.add(pair));
      },
    );
  } // _buildRow


  // _pushSaved
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void> (
          builder: (BuildContext context) {
            final tiles = _saved.map(
                (WordPair pair) {
                  return ListTile(
                    title: Text(
                      pair.asPascalCase,
                      style: _biggerFont,
                    ),
                  );
                },
            );
            final divided = ListTile.divideTiles(
                context: context,
                tiles: tiles,
            ).toList();

            return Scaffold(
              appBar: AppBar(
                title: Text('Saved Suggestion'),
              ),
              body: ListView( children: divided, ),
            );
          })
    ); // Navigator
  } // _pushSaved
} // RandomWordsState

// RandomWords
class RandomWords extends StatefulWidget {

  @override
  _RandomWordsState createState() => new _RandomWordsState();

} // RandomWords