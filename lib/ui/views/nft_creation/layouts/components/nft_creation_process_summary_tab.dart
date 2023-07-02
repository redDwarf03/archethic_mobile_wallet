/// SPDX-License-Identifier: AGPL-3.0-or-later
part of '../nft_creation_process_sheet.dart';

class NFTCreationProcessSummaryTab extends ConsumerStatefulWidget {
  const NFTCreationProcessSummaryTab({
    super.key,
  });

  @override
  ConsumerState<NFTCreationProcessSummaryTab> createState() =>
      _NFTCreationProcessSummaryTabState();
}

class _NFTCreationProcessSummaryTabState
    extends ConsumerState<NFTCreationProcessSummaryTab> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(ThemeProviders.selectedTheme);
    final localizations = AppLocalization.of(context)!;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final accountSelected =
        ref.watch(AccountProviders.selectedAccount).valueOrNull;
    final nftCreationArgs = ref.read(
      NftCreationFormProvider.nftCreationFormArgs,
    );
    final nftCreation =
        ref.watch(NftCreationFormProvider.nftCreationForm(nftCreationArgs));
    final nftCreationNotifier = ref.watch(
      NftCreationFormProvider.nftCreationForm(nftCreationArgs).notifier,
    );
    final connectivityStatusProvider = ref.watch(connectivityStatusProviders);

    if (accountSelected == null) return const SizedBox();

    if (nftCreation.file != null) {
      return ArchethicScrollbar(
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom + 80),
          child: SizedBox(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: FeeInfos(
                    asyncFeeEstimation: nftCreation.feeEstimation,
                    estimatedFeesNote: localizations.estimatedFeesAddNFTNote,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          AppButtonTinyConnectivity(
                            AppLocalization.of(context)!.createTheNFT,
                            Dimens.buttonTopDimens,
                            key: const Key('createTheNFT'),
                            icon: RpgAwesome.mining_diamonds,
                            onPressed: () async {
                              final isNameOk =
                                  nftCreationNotifier.controlName(context);
                              final isFileOk =
                                  nftCreationNotifier.controlFile(context);

                              if (isNameOk && isFileOk) {
                                nftCreationNotifier.setNftCreationProcessStep(
                                  NftCreationProcessStep.confirmation,
                                );
                              }
                            },
                            disabled: !nftCreation.canCreateNFT,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const NFTCreationProcessFilePreview(),
                //const NFTCreationProcessFileAccess(
                //  readOnly: true,
                //),
                const NFTCreationProcessPropertiesList(
                  readOnly: true,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
