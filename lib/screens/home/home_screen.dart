import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nongple/blocs/blocs.dart';
import 'package:nongple/widgets/widgets.dart';
import 'package:nongple/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  final String name;

  HomeScreen({Key key, @required String name})
      : this.name = name,
        super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name;
  HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.add(ListLoading());
    this.name = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print('Height: $height, Width: $width');
    return BlocListener(
        bloc: _homeBloc,
        listener: (context, state) {
          if (state is FacilityListSet) {
            LoadingDialog.dismiss(context, () => null);
          } else {
            _homeBloc.add(GetFacilityList());
            LoadingDialog.onLoading(context);
          }
        },
        child: Scaffold(
          backgroundColor: bodyColor,
          appBar: AppBar(
            backgroundColor: appBarColor,
            elevation: 0.0,
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name 님\n오늘도 풍성한 하루 되세요',
                    style: homeMainTitle,
                    maxLines: 3,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      '$year년 $month월 $day일 $weekday',
                      style: homeSubTitle,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.018,
                  ),
                  Container(
                    child: BlocProvider.value(
                      value: _homeBloc,
                      child: ChipButton(),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.016,
                  ),
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is FacilityListSet) {
                        return (state.facList.length == 0)
                            ? ButtonCard()
                            : Expanded(
                          child: BlocProvider.value(
                            value: _homeBloc,
                            child: HomeScreenListViewBuilder(),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Column(
                                children: <Widget>[
                                  Card(
                                    elevation: 4.0,
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Container(
                                      height: height / 5,
                                      width: width,
                                      padding: EdgeInsets.fromLTRB(
                                          width / 25, height / 35, width / 25, height / 60),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: width * 0.5,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: height*0.03,
                                                        width: width*0.5,
                                                        decoration: BoxDecoration(
                                                            color: Color(0xFFBDBDBD),
                                                          borderRadius: BorderRadius.circular(20.0)
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height*0.01,
                                                      ),
                                                      Container(
                                                        height: height*0.015,
                                                        width: width*0.35,
                                                        decoration: BoxDecoration(
                                                            color: Color(0x80BDBDBD),
                                                            borderRadius: BorderRadius.circular(20.0)
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: height*0.08,
                                                  width: width*0.18,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFBDBDBD),
                                                      borderRadius: BorderRadius.circular(20.0)
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              height: height *0.1,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Chip(
                                                    backgroundColor: Colors.white,
                                                    elevation: 1.0,
                                                    label: SizedBox(
                                                      height: height*0.027,
                                                      width: width*0.28,
                                                      child: FittedBox(
                                                        child: Text(
                                                          ' 자세히보기 ',
                                                          style: cardWidgetDetailButtonStyle,
                                                        ),
                                                      ),
                                                    )
                                                  ),
                                                  Container(
                                                    child: Card(
                                                      elevation: 2.0,
                                                      child: Icon(
                                                        Icons.category,
                                                        color: Color(0xFFBDBDBD),                                                     size: 25,
                                                      ),
                                                      shape: CircleBorder(),
                                                      clipBehavior: Clip.antiAlias,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.017,
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
