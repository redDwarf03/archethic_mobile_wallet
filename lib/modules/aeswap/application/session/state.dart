import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart';

extension EnvironmentAddressesExt on Environment {
  String get aeETHUCOPoolAddress => switch (this) {
        Environment.mainnet =>
          '000090C5AFCC97C2357E964E3DDF5BE9948477F7C1DE2C633CDFC95B202970AEA036',
        Environment.testnet =>
          '0000818EF23676779DAE1C97072BB99A3E0DD1C31BAD3787422798DBE3F777F74A43',
        Environment.devnet =>
          '0000c94189acdf76cd8d24eab10ef6494800e2f1a16022046b8ecb6ed39bb3c2fa42',
      };

  String get aeETHUCOFarmLegacyAddress => switch (this) {
        Environment.mainnet =>
          '0000474A5B5D261A86D1EB2B054C8E7D9347767C3977F5FC20BB8A05D6F6AFB53DCC',
        Environment.testnet =>
          '0000208A670B5590939174D65F88140C05DDDBA63C0C920582E12162B22F3985E510',
        Environment.devnet =>
          '00008e063dffde69214737c4e9e65b6d9d5776c5369729410ba25dab0950fbcf921e',
      };
  String get aeETHUCOFarmLockAddress => switch (this) {
        Environment.mainnet =>
          '0000b2339aadf5685b1c8d400c9092c921e51588dc049e097ec9437017e7dded0feb',
        Environment.testnet =>
          '0000CAF8D5BAA374A2878FD87760A2A4AC9F5232DBB4F1143157A2006F95FFF1B40E',
        Environment.devnet =>
          '00007338a899446b8d211bb82b653dfd134cc351dd4060bb926d7d9c7028cf0273bf',
      };

  String get nodeRewardsChain => switch (this) {
        Environment.mainnet =>
          '000088CCDFB1DAC2B12C0BBD41A7AC0308693AF9DA0DE045FD2A11E3CE0BA9A49CA2',
        Environment.testnet => 'none',
        Environment.devnet => 'none',
      };
}
