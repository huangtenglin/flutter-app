import 'package:flutter/material.dart';
import 'package:my_multi_platform_app/features/playback/playback_engine.dart';
import 'package:my_multi_platform_app/mock/items_mock.dart';
import 'package:my_multi_platform_app/mock/track_mock.dart';
import 'package:my_multi_platform_app/widgets/stateful/tracker_map.dart';
import 'package:my_multi_platform_app/widgets/stateful/tracker_map_models.dart';
import 'package:my_multi_platform_app/widgets/stateless/playback_bar.dart';

class FindPage extends StatefulWidget {
  const FindPage({super.key, required this.itemId});

  final String itemId;

  @override
  State<FindPage> createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  late final PlaybackEngine _engine;

  @override
  void initState() {
    super.initState();
    _engine = PlaybackEngine()..load(TrackMock.points());
  }

  @override
  void dispose() {
    _engine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = ItemsMock.byId(widget.itemId);
    return Scaffold(
      appBar: AppBar(
        title: Text(item?.name ?? 'Open map'),
      ),
      body: Column(
        children: [
          Expanded(
            child: TrackerMap(
              mode: TrackerMapMode.playback,
              track: TrackMock.points(),
              engine: _engine,
            ),
          ),
          PlaybackBar(engine: _engine),
        ],
      ),
    );
  }
}
