import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/screen_schedule/schedule_bloc.dart';
import 'package:union_player_app/screen_schedule/schedule_item_view.dart';
import 'package:union_player_app/screen_schedule/schedule_state.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';

import '../utils/widgets/snack_bar.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScheduleBloc, ScheduleState>(
      listener: (context, state) => showSnackBar(context, messageText: state.errorText),
      builder: (context, state) => (state is ScheduleLoadedState) ? _loadedPage(context, state) : _loadingPage(),
      bloc: get<ScheduleBloc>(),
    );
  }

  Widget _loadingPage() => const Center(child: CircularProgressIndicator());

  Widget _loadedPage(BuildContext context, ScheduleLoadedState state) {
    return RefreshIndicator(
      onRefresh: () async {
        //TODO: отправить событие на принудительную загрзку данных
        //context.read<ScheduleBloc>().add();
      },
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(height: listViewDividerHeight),
        itemCount: state.items.length,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsets.all(scheduleItemPadding),
          child: _programElement(context, state.items[index]),
        ),
      ),
    );
  }

  Widget _programElement(BuildContext context, ScheduleItemView element) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _imageWidget(element),
        Expanded(child: _textWidget(element, context)),
        _startTimeWidget(element, context),
      ],
    );
  }

  Text _startTimeWidget(ScheduleItemView element, BuildContext context) =>
      Text(element.start, style: Theme.of(context).textTheme.headline6, overflow: TextOverflow.ellipsis);

  Text _titleWidget(ScheduleItemView element, BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: titleFontSize);
    return Text(
      element.title,
      style: titleStyle,
      softWrap: true,
      textAlign: TextAlign.start,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Text _artistWidget(ScheduleItemView element, BuildContext context) {
    final artistStyle = Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: artistFontSize);
    return Text(
      element.artist,
      style: artistStyle,
      softWrap: true,
      textAlign: TextAlign.start,
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
    );
  }

  Widget _imageWidget(ScheduleItemView element) {
    const radius = 6.0;
    const offset = 6.0;

    late final Image image;
    if (element.imageUri != null && element.imageUri!.path.isNotEmpty) {
      final file = File.fromUri(element.imageUri!);
      image = Image.file(file, width: scheduleImageSide, height: scheduleImageSide, fit: BoxFit.cover);
    } else {
      image = Image.asset(logoImage, width: scheduleImageSide, height: scheduleImageSide, fit: BoxFit.cover);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(color: Colors.black45, offset: Offset(offset, offset), blurRadius: 15, spreadRadius: 0),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: image,
      ),
    );
  }

  Widget _textWidget(ScheduleItemView element, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: scheduleItemPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleWidget(element, context),
          SizedBox(height: scheduleItemPadding),
          _artistWidget(element, context),
        ],
      ),
    );
  }
}
