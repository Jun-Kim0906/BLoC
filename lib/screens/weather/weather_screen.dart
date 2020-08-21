import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nongple/blocs/blocs.dart';
import 'package:nongple/utils/utils.dart';
import 'package:nongple/widgets/custom_icons/custom_icons.dart';
import 'package:nongple/widgets/widgets.dart';
import 'package:nongple/models/models.dart';

class WeatherScreen extends StatefulWidget {
  final Facility facility;
  const WeatherScreen({@required this.facility});
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherBloc _weatherBloc;
  @override
  void initState() {
    super.initState();
    _weatherBloc = BlocProvider.of<WeatherBloc>(context);
    _weatherBloc.add(WeatherLoading());
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocListener(
      bloc: _weatherBloc,
      listener: (BuildContext context, WeatherState state){
        if(state is WLoading){
        _weatherBloc.add(GetWeather(
        fid: widget.facility.fid,
        nx: widget.facility.lat,
        ny: widget.facility.lng));
          LoadingDialog.onLoading(context);
        }else{
          LoadingDialog.dismiss(context, ()=>null);
        }
      },
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherListSet) {
            return Padding(
              padding: EdgeInsets.fromLTRB(width*0.055, 0.0, width*0.055, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.042,
                    child: AutoSizeText(
                      '$year년 $month월 $day일',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Container(
                    height: height * 0.274,
                    width: width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 0.021,
                        ),
                        SizedBox(
                          height: height * 0.111,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: (int.parse(state.skyList_short[0].fcstValue) <=
                                1)
                                ? Icon(
                              CustomIcons.sun,
                              size: 100,
                              color: sun,
                            )
                                : (int.parse(state.skyList_short[0].fcstValue) >
                                1 &&
                                int.parse(
                                    state.skyList_short[0].fcstValue) <
                                    4)
                                ? Icon(
                              CustomIcons.cloud,
                              size: 100,
                              color: cloud,
                            )
                                : Icon(
                              CustomIcons.rain,
                              size: 100,
                              color: rain,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.021,
                        ),
                        SizedBox(
                          height: height * 0.089,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    AutoSizeText(
                                      '현재기온',
                                      style: TextStyle(color: Color(0xFF2F80ED), fontSize: 13),
                                      maxLines: 1,
                                    ),
                                    SizedBox(
                                      height: height * 0.001,
                                    ),
                                    AutoSizeText(
                                      state.tmpList_short[0].fcstValue +
                                          degrees +
                                          'C',
                                      style: TextStyle(
                                          fontSize: 32.0,
                                          fontWeight: FontWeight.bold
                                      ),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: width * 0.125,
                                ),
                                Column(
                                  children: [
                                    AutoSizeText(
                                      '습도',
                                      style: TextStyle(color: Color(0xFF2F80ED), fontSize: 13),
                                      maxLines: 1,
                                    ),
                                    SizedBox(
                                      height: height * 0.001,
                                    ),
                                    AutoSizeText(
                                      state.humidList_short[0].fcstValue + '%',
                                      style: TextStyle(
                                          fontSize: 32.0,
                                          fontWeight: FontWeight.bold
                                      ),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1.0,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
//                    itemCount: state.tmpList.length,
                      itemCount: 8,
                      itemBuilder: (BuildContext context, int index) {
                        String fcstTime = state.tmpList[index].fcstTime;
                        return ListTile(
                          leading: SizedBox(
                            height: height * 0.028,
                            width: width * 0.133,
                              child: AutoSizeText(
                                  fcstTime[0] + fcstTime[1] + '시',
                                style: TextStyle(fontSize: 16.0),
                                maxLines: 1,
                              ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: height * 0.028,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: (int.parse(state.skyList[index].fcstValue) <= 1)
                                      ? Icon(
                                    CustomIcons.sun,
                                    color: sun,
                                  )
                                      : (int.parse(state.skyList[index].fcstValue) >
                                      1 &&
                                      int.parse(state
                                          .skyList[index].fcstValue) <
                                          4)
                                      ? Icon(
                                    CustomIcons.cloud,
                                    color: cloud,
                                  )
                                      : Icon(
                                    CustomIcons.rain,
                                    color: rain,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.144,
                              ),
                              SizedBox(
                                height: height * 0.032,
                                width: width * 0.133,
                                child: AutoSizeText(
                                    state.tmpList[index].fcstValue + degrees + 'C',
                                  style: TextStyle(fontSize: 16.0),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          trailing: SizedBox(
                            height: height * 0.032,
                            width: width * 0.133,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AutoSizeText(
                                  state.humidList[index].fcstValue + '%',
                                  style: TextStyle(fontSize: 16.0),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Image.asset('assets/no_result.png'),
            );
          }
        },
      ),
    );
  }
}
