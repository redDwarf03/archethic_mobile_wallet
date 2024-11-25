import 'package:aewallet/util/universal_platform.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_info.freezed.dart';

@freezed
class DeviceInfoState with _$DeviceInfoState {
  const DeviceInfoState._();
  const factory DeviceInfoState.android({
    required int version,
  }) = _DeviceInfoStateAndroid;

  const factory DeviceInfoState.other() = _DeviceInfoStateOther;
}

class DeviceInfo {
  DeviceInfo._({required DeviceInfoState state}) : _state = state;
  static DeviceInfo? _instance;

  final DeviceInfoState _state;

  /// Reads the DeviceInfo details
  static DeviceInfoState get state {
    if (_instance == null) {
      throw Exception('DeviceInfo must be initialized first');
    }
    return _instance!._state;
  }

  /// Initializes the DeviceInfo.
  static Future<void> init() async {
    final state = await _createState;
    _instance = DeviceInfo._(state: state);
  }

  static Future<DeviceInfoState> get _createState async {
    if (!UniversalPlatform.isAndroid) {
      return const DeviceInfoState.other();
    }

    final plugin = DeviceInfoPlugin();

    final androidInfo = await plugin.androidInfo;
    return DeviceInfoState.android(
      version: androidInfo.version.sdkInt,
    );
  }
}
