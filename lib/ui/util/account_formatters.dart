import 'package:aewallet/model/data/account.dart';

extension AccountFormatters on Account {
  String get format {
    final decodedName = Uri.decodeFull(name);
    return decodedName.length > 1 && decodedName.startsWith('@')
        ? decodedName.replaceFirst('@', '')
        : decodedName;
  }
}
