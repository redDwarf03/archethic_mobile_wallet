// //@Timeout(Duration(seconds: 90))
// import 'package:aewallet/main.dart' as app;
// import 'package:patrol/patrol.dart';

// import 'action/import_wallet.dart';
// import 'action/pin_confirmation.dart';
// import 'config/config.dart';

// void main() {
//   patrolTest('As a user I can create a NFT',
//       nativeAutomatorConfig: nativeAutomatorConfig, ($) async {
//     await app.main();
//     await importWalletAction($);

//     await $(#bottomBarAddressNFTlink).tap();
//     await $(#createNFT).tap();
//     await $(#nftCreationField).first.enterText('nftTest');
//     await $(#next).tap();
//     await $(#nftImportPhoto).tap();
//     // `TODO`(reddwarf03): Add mock with a simple picture
//     await $(#next).tap();
//     await $(#nftName).enterText('nftTest');
//     await $(#nftValue).enterText('10');
//     await $(#next).tap();
//     await $(#nftCreationConfirmation).tap();
//     await $(#createTheNFT).tap();

//     await validPinConfirmation($);
//   });
// }
