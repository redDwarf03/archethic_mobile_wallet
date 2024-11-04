import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class AddCustomTokenFormState with _$AddCustomTokenFormState {
  const factory AddCustomTokenFormState({
    @Default('') String tokenAddress,
    @Default('') String errorText,
    AEToken? token,
    @Default(0) double userTokenBalance,
  }) = _AddCustomTokenFormState;
  const AddCustomTokenFormState._();

  bool get isControlsOk => errorText == '' && token != null;
}
