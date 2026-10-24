import 'package:my_multi_platform_app/features/home/models/home_summary.dart';
import 'package:my_multi_platform_app/mock/home_mock.dart';

class HomeApi {
  Future<HomeSummary> fetchSummary({bool forceFresh = false}) {
    return HomeMock.fetchSummary(checkedJustNow: forceFresh);
  }
}
