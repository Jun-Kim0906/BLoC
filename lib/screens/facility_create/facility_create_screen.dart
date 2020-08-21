import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:nongple/blocs/add_facilitiy_bloc/bloc.dart';
import 'package:nongple/widgets/widgets.dart';
import 'package:nongple/screens/screens.dart';

class FacilityCreateScreen extends StatefulWidget {
  @override
  _FacilityCreateScreenState createState() => _FacilityCreateScreenState();
}

class _FacilityCreateScreenState extends State<FacilityCreateScreen> {
  final focusNode = FocusNode();
  TextEditingController facilityNameController = TextEditingController();
  AddFacilityBloc _addFacilityBloc;
  double height;
  double width;

  bool get ispopulated => facilityNameController.text.isNotEmpty;

  bool isNextButtonEnabled() {
    return ispopulated;
  }

  @override
  void initState() {
    super.initState();
    _addFacilityBloc = BlocProvider.of<AddFacilityBloc>(context);
    facilityNameController.addListener(() {
      _addFacilityBloc
          .add(FacilityNameChanged(facilityname: facilityNameController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          color: Color(0xFF2F80ED),
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(width*0.05, 0.0, width*0.05, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: height / 11,
            ),
            SizedBox(
              height: height*0.111,
              width: width*0.544,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: Text(
                  '시설 이름을 \n입력해 주세요 ' + EmojiParser().emojify('🙂'),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: height*0.04,
            ),
            SizedBox(
              height: height*0.0231,
              width: width*0.131,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: Text(
                  '시설 이름',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ),
            TextField(
              style: TextStyle(fontWeight: FontWeight.bold),
              controller: facilityNameController,
              decoration: InputDecoration(
                hintText: '이름 입력하기',
              ),
              focusNode: focusNode,
            )
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<AddFacilityBloc, AddFacilityState>(
          builder: (context, state) {
        return BottomNavigationButton(
            title: '다음',
            onPressed: state.isNameValid
                ? () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                BlocProvider<AddFacilityBloc>.value(
                                  value: _addFacilityBloc,
                                  child: FacilityCreateScreen2(
                                    facilityName: state.facilityName,
                                  ),
                                )));
                  }
                : null);
      }),
    );
  }
}
