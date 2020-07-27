import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nongple/blocs/blocs.dart';
import 'package:nongple/utils/utils.dart';

class DictionaryScreen extends StatefulWidget {
  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  TextEditingController _textEditingController = TextEditingController();
  DictionaryBloc _dictionaryBloc;

  @override
  void initState() {
    super.initState();
    _dictionaryBloc = BlocProvider.of<DictionaryBloc>(context);
    _textEditingController.addListener(() {
      _dictionaryBloc
          .add(SearchTextChanged(searchText: _textEditingController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        searchBar(),
//        Expanded(
//          child: ListView(
//            children: <Widget>[
//              _matchedList(context, state),
//              _totalList(context, state)
//            ],
//          ),
//        ),
      ],
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20),
            width: 65,
            child: Text(
              '용어',
              style: TextStyle(
                  color: Color(0xFF2F80ED),
                  fontWeight: FontWeight.w600,
                  fontSize: 21),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 20),
              child: TextField(
                autofocus: true,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF2F80ED))),
                ),
//                cursorColor: mainColor,
                onChanged: (value) {
//                  _dictionaryBloc.add(SearchTextChanged(searchText: value));
                },
                controller: _textEditingController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
              ),
            ),
          ),
        ],
      ),
    );
  }

//  Widget _mathceList(BuildContext context, DictionaryState state){
//    return Column(
//      children: List.generate(length, (index) => null).toList()
//    );
//  }
//
//  Widget _matchedList(BuildContext context, DictionaryState state) {
//    return ColumnBuilder(
//        itemBuilder: (context, index) {
//          return Padding(
//            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//            child: InkWell(
//              onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (BuildContext context) =>
//                        BlocProvider<DictionaryBloc>.value(
//                          value: _dictionaryBloc,
//                          child: DictionaryDetailPage(
//                            wordNo:
//                            state.matchDictionaryList[index].wordNumber,
//                            name: state.matchDictionaryList[index].wordName,
//                          ),
//                        )));
//              },
//              child: Container(
//                alignment: Alignment.centerLeft,
//                child: Text(
//                  "${state.matchDictionaryList[index].wordName}",
//                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
//                ),
//              ),
//            ),
//          );
//        },
//        itemCount: state.matchDictionaryList.length);
//  }


}
