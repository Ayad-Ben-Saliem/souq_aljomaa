import 'package:souq_aljomaa/utils.dart';

class Settings {
  final String? serverUrl;
  final bool showAllData;

  Settings({this.serverUrl, this.showAllData = false});

  Settings.copyWith(
    Settings settings, {
    String? serverUrl,
    bool? showAllData,
  })  : serverUrl = serverUrl ?? settings.serverUrl,
        showAllData = showAllData ?? settings.showAllData;

  Settings copyWith({
    String? serverUrl,
    bool? showAllData,
  }) =>
      Settings.copyWith(
        this,
        serverUrl: serverUrl,
        showAllData: showAllData,
      );

  JsonMap toJson() => {
        'serverUrl': serverUrl,
        'showAllData': showAllData,
      };

  @override
  String toString() => Utils.getPrettyString(toJson());
}
