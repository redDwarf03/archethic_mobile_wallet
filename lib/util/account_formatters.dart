import 'package:aewallet/model/data/account.dart';
import 'package:aewallet/model/data/account_token.dart';

extension AccountFormatters on Account {
  String get format {
    final decodedName = Uri.decodeFull(name);
    return decodedName.length > 1 && decodedName.startsWith('@')
        ? decodedName.replaceFirst('@', '')
        : decodedName;
  }

  String get nameDisplayed {
    var result = name;
    if (name.startsWith('archethic-wallet-')) {
      result = result.replaceFirst('archethic-wallet-', '');
    }
    if (name.startsWith('aeweb-')) {
      result = result.replaceFirst('aeweb-', '');
    }

    return Uri.decodeFull(
      result,
    );
  }

  List<AccountToken> getAccountNFTFiltered() {
    return <AccountToken>[
      ...accountNFT ?? [],
      // A collection of NFT has the same address for all the sub NFT, we only want to display one NFT in that case
      ...(accountNFTCollections?.where(
            (e) => <String>{}.add(e.tokenInformation?.address ?? ''),
          ) ??
          []),
    ];
  }
}
