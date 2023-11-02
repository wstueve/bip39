import 'dart:io';

import 'package:bip39_dart/bip39.dart' as bip39;

import '../lib/src/wordlists/english.dart';

//tbe purpose of this file is to test mneumonic generation
//and to generate data for the wordcount.csv file
//This can then be analyzed and ensure the wordlist is
//as random as possible
void main() async {
  var wordCount = {};
  
  var file2 = File('wordcount.csv'); 
  if (!file2.existsSync()) {
    //load the file from the english wordlist
    file2.writeAsStringSync('row,word,count\n');
    var wordRow = 1;
    WORDLIST.forEach((word) {
      wordCount[word] = 0;
      file2.writeAsStringSync('$wordRow,$word,0\n', mode: FileMode.append);
      wordRow++;
    });
  }

  var lines = file2.readAsLinesSync().skip(1);

  for (var line in lines) {
    var parts = line.split(',');
    wordCount[parts[1]] = int.parse(parts[2]);
  }

  for (var i = 1; i <= 100000000; i++) {
    var mnemonic = bip39.generateMnemonic();
    //split the words into an array
    var words = mnemonic.split(' ');

    //add the word to map and keep a running 
    //count of how many times it appears
    for (var word in words) {
      wordCount[word] += 1;
    }

    if (i % 100000 == 0) {
      print('iteration $i');
      //save the words and count to a csv file
      var file = File('wordcount.csv');
      file.writeAsStringSync('row,word,count\n');
      var row = 1;
      wordCount.forEach((word, count) {
        file.writeAsStringSync('$row,$word,$count\n', mode: FileMode.append);
        row++;
      });
    }
  }
}
