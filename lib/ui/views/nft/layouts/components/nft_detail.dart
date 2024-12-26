import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/nft/nft.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/model/data/account.dart';
import 'package:aewallet/model/data/account_token.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/views/nft/layouts/components/nft_detail_collection.dart';
import 'package:aewallet/ui/views/nft/layouts/components/nft_detail_properties.dart';
import 'package:aewallet/ui/views/nft/layouts/components/thumbnail/nft_thumbnail.dart';
import 'package:aewallet/ui/views/transfer/bloc/state.dart';
import 'package:aewallet/ui/views/transfer/layouts/transfer_sheet.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/qr_code_with_options.dart';
import 'package:aewallet/ui/widgets/components/scrollbar.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

class NFTDetail extends ConsumerStatefulWidget {
  const NFTDetail({
    super.key,
    required this.name,
    required this.address,
    required this.symbol,
    required this.properties,
    required this.collection,
    required this.tokenId,
    required this.detailCollection,
    this.nameInCollection,
  });

  final String name;
  final String address;
  final String symbol;
  final String tokenId;
  final List<dynamic> collection;
  final Map<String, dynamic> properties;
  final String? nameInCollection;
  final bool detailCollection;

  static const routerPage = '/nft_detail';

  @override
  ConsumerState<NFTDetail> createState() => _NFTDetailState();
}

class _NFTDetailState extends ConsumerState<NFTDetail>
    implements SheetSkeletonInterface {
  @override
  Widget build(BuildContext context) {
    final accountSelected = ref.watch(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );

    if (accountSelected == null) return const SizedBox();

    return SheetSkeleton(
      appBar: getAppBar(context, ref),
      floatingActionButton: getFloatingActionButton(context, ref),
      sheetContent: getSheetContent(context, ref),
      thumbVisibility: false,
    );
  }

  @override
  Widget getFloatingActionButton(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final accountSelected = ref.watch(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (widget.collection.isEmpty)
          FutureBuilder(
            future: ref.watch(
              NFTProviders.isAccountOwner(
                accountSelected!.genesisAddress,
                widget.address,
                widget.tokenId,
              ).future,
            ),
            builder: (
              BuildContext context,
              AsyncSnapshot<bool> snapshot,
            ) {
              if (snapshot.hasData) {
                if (snapshot.data == true) {
                  return Row(
                    children: <Widget>[
                      AppButtonTinyConnectivity(
                        localizations.send,
                        Dimens.buttonTopDimens,
                        key: const Key('sendNFT'),
                        onPressed: () async {
                          final accountToken = getAccountToken(accountSelected);
                          await context.push(
                            TransferSheet.routerPage,
                            extra: {
                              'transferType': TransferType.nft.name,
                              'accountToken': const AccountTokenConverter()
                                  .toJson(accountToken),
                              'recipient': const TransferRecipient.address(
                                address: Address(address: ''),
                              ).toJson(),
                              'tokenId': widget.tokenId,
                            },
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Symbols.info,
                        size: 15,
                        weight: IconSize.weightM,
                        opticalSize: IconSize.opticalSizeM,
                        grade: IconSize.gradeM,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        AppLocalizations.of(context)!.nftNotOwnerInfo,
                        style: ArchethicThemeStyles.textStyleSize12W100Primary,
                      ),
                    ],
                  );
                }
              } else {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 17),
                  child: SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(
                      color:
                          ArchethicThemeStyles.textStyleSize10W100Primary.color,
                      strokeWidth: 1,
                    ),
                  ),
                );
              }
            },
          ),
        Row(
          children: <Widget>[
            AppButtonTinyConnectivity(
              localizations.viewExplorer,
              Dimens.buttonBottomDimens,
              key: const Key('viewExplorer'),
              onPressed: () async {
                await launchUrl(
                  Uri.parse(
                    '${ref.read(SettingsProviders.settings).network.getLink()}/explorer/transaction/${widget.address}',
                  ),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SheetAppBar(
      widgetLeft: BackButton(
        key: const Key('back'),
        color: ArchethicTheme.text,
        onPressed: () {
          context.pop();
        },
      ),
      title: widget.name,
      widgetRight: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: InkWell(
          child: const Icon(
            Symbols.qr_code_scanner,
            size: 30,
            weight: IconSize.weightM,
            opticalSize: IconSize.opticalSizeM,
            grade: IconSize.gradeM,
          ),
          onTap: () {
            showDialog(
              context: context,
              useRootNavigator: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: ArchethicTheme.backgroundPopupColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                  ),
                  contentPadding: const EdgeInsets.only(top: 10),
                  content: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                      bottom: 40,
                    ),
                    child: QRCodeWithOptions(
                      infoQRCode: widget.address.toUpperCase(),
                      size: 150,
                      messageCopied: localizations.addressCopied,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 250,
      child: Column(
        children: <Widget>[
          if (widget.symbol.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                '[${widget.symbol}]',
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
            ),
          Expanded(
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: widget.collection.isEmpty
                    ? ArchethicScrollbar(
                        child: Column(
                          children: <Widget>[
                            NFTThumbnail(
                              nameInCollection: widget.nameInCollection,
                              address: widget.address,
                              properties: widget.properties,
                              withContentInfo: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            NFTDetailProperties(
                              properties: widget.properties,
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          NFTDetailProperties(
                            properties: widget.properties,
                          ),
                          Expanded(
                            child: NFTDetailCollection(
                              address: widget.address,
                              collection: widget.collection,
                              tokenId: widget.tokenId,
                              name: widget.name,
                              symbol: widget.symbol,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AccountToken getAccountToken(Account accountSelected) {
    // Single token selected
    if (accountSelected.accountNFT!.any(
      (element) => element.tokenInformation!.id == widget.tokenId,
    )) {
      return accountSelected.accountNFT!.firstWhere(
        (element) => element.tokenInformation!.id == widget.tokenId,
      );
      // Collection token selected
    } else if (accountSelected.accountNFTCollections!.any(
      (element) => element.tokenInformation!.id == widget.tokenId,
    )) {
      return accountSelected.accountNFTCollections!.firstWhere(
        (element) => element.tokenInformation!.id == widget.tokenId,
      );
      // Single token from a collection selected
    } else {
      return accountSelected.accountNFTCollections!.firstWhere(
        (element) =>
            element.tokenInformation!.address == widget.address &&
            element.tokenInformation!.tokenCollection!.any(
              (element) => element['id'] == widget.tokenId,
            ),
      );
    }
  }
}
