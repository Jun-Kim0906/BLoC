import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nongple/blocs/blocs.dart';
import 'package:nongple/screens/dictionary/dictionary_detail_screen.dart';
import 'package:nongple/utils/utils.dart';

class DictionaryScreen extends StatefulWidget {
  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final focusNode = FocusNode();
  DictionaryBloc _dictionaryBloc;
  bool searched = false;
  FocusScopeNode currentFocus;

  @override
  void initState() {
    super.initState();
    _dictionaryBloc = BlocProvider.of<DictionaryBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _dictionaryBloc,
        builder: (context, DictionaryState state) {
          return GestureDetector(
            onTap: (){
              currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Column(
              children: <Widget>[
                searchBar(),
                state.searching
                    ? Expanded(
                        child: Center(
                            child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 0, 61, 165)),
                        )),
                      )
                    : searched==false
                        ? Container()
                        : state.searchedItems.length == 0
                            ? Expanded(
                                child: Center(
                                  child: Image.asset('assets/no_result.png'),
                                ),
                              )
                            : Expanded(
                                child: _matchedList(context, state),
                              ),
              ],
            ),
          );
        });
  }

  Widget searchBar() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20),
            child: AutoSizeText(
              '용어',
              style: TextStyle(
                  color: Color(0xFF2F80ED),
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
              maxLines: 1,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 20),
              child: TextField(
//                focusNode: currentFocus,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF2F80ED))),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  _dictionaryBloc.add(SearchTextChanged(searchText: value));
                },
                onSubmitted: (value) {
                  searched=true;
                  _dictionaryBloc.add(Searching());
                  _dictionaryBloc.add(TextOnSubmitted(searchText: value));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _matchedList(BuildContext context, DictionaryState state) {
    return Column(
        children: List.generate(
            state.searchedItems.length,
            (index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  BlocProvider<DictionaryBloc>.value(
                                    value: _dictionaryBloc,
                                    child: DictionaryDetailScreen(
                                      wordNo:
                                          state.searchedItems[index].wordNumber,
                                      wordNm:
                                          state.searchedItems[index].wordName,
                                    ),
                                  )));
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        "${state.searchedItems[index].wordName}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                      ),
                    ),
                  ),
                )).toList());
  }
}
