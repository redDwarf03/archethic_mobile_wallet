import 'package:aewallet/ui/util/account_formatters.dart';
import 'package:aewallet/ui/util/address_formatters.dart';
import 'package:aewallet/ui/views/transfer/bloc/state.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';

extension TransferRecipientFormatters on TransferRecipient {
  String format(AppLocalizations localizations) => when(
        address: (address) => address.address ==
                '00000000000000000000000000000000000000000000000000000000000000000000'
            ? localizations.burnAddressLbl
            : AddressFormatters(address.address!).getShortString(),
        account: (account) => account.format,
        unknownContact: (name) => name.replaceFirst('@', ''),
      );
}
