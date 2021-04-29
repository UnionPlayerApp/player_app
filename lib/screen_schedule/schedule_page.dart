import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/screen_schedule/schedule_bloc.dart';
import 'package:union_player_app/screen_schedule/schedule_state.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';
import 'package:koin_flutter/koin_flutter.dart';


class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>
      (builder: (BuildContext context, ScheduleState state){
      if (state is ScheduleInitialState){
        return Center(
         child: CircularProgressIndicator(),
        );
      }
      if (state is ScheduleLoadedState) {
        return _listView(context, state);
      }
      else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    },
    bloc: get<ScheduleBloc>(),
    );
  }

  _listView(context, state) {
    return
      ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(
        height: listViewDividerHeight),
          itemCount: state.items.length,
          itemBuilder: (BuildContext context, int index) {
          return _programElement(state.items[index]);
          });
  }

  _programElement(element){
    late Image image;
    if (element.imageUrl != null && element.imageUrl != '') {
      image = Image.network(element.imageUrl!,
          width: scheduleImageSide,
          height: scheduleImageSide,
          fit: BoxFit.cover);
    } else {
      image = Image.asset(LOGO_IMAGE,
          width: scheduleImageSide,
          height: scheduleImageSide,
          fit: BoxFit.cover);
    }
    return Container(
        color: Colors.white10,
        margin: allSidesMargin,
        height: scheduleItemHeight,
        child: Row(children: [
          image,
          Expanded(
              child: Container(
                  padding: programTextLeftPadding,
                  child: Column(children: [
                    Row(children: [
                      Expanded(
                          child: Text(
                        element.title,
                        style: TextStyle(fontSize: titleFontSize),
                        softWrap: true,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      Text(element.startTime,
                          style: TextStyle(fontSize: titleFontSize),
                          overflow: TextOverflow.ellipsis),
                    ]),
                    Container(
                        padding: programBodyTopPadding,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          element.text,
                          style: TextStyle(fontSize: bodyFontSize),
                          softWrap: true,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ))
                  ])))
        ]));
  }
}
