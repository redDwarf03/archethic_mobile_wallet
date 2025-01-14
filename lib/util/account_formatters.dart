import 'package:aewallet/model/data/account.dart';

extension AccountFormatters on Account {
  String get format {
    return Uri.decodeFull(name);
  }

  String get nameDisplayed {
    var result = name;
    if (name.startsWith('archethic-wallet-')) {
      result = result.replaceFirst('archethic-wallet-', '');
    } else if (name.startsWith('aeweb-')) {
      result = result.replaceFirst('aeweb-', '');
    }

    return Uri.decodeFull(
      result,
    );
  }
}
