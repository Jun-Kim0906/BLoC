import 'package:meta/meta.dart';

class Dictionary {
  final String wordName;
  final String wordNumber;

  const Dictionary({
    @required this.wordName,@required this.wordNumber,
  });

  factory Dictionary.fromJson(Map<String, dynamic> js) {
    return Dictionary(
      wordName: js['wordNm'],
      wordNumber: js['wordNo'],
    );
  }

  String getName() {
    return wordName;
  }

  String getNumber() {
    return wordNumber;
  }
}
