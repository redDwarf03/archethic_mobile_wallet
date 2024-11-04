import 'package:aewallet/domain/repositories/features_flags.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/formatters.dart';
import 'package:aewallet/ui/views/tokens_detail/layouts/token_detail_sheet.dart';
import 'package:aewallet/ui/views/tokens_list/bloc/provider.dart';
import 'package:aewallet/ui/views/tokens_list/layouts/components/custom_token_add_btn.dart';
import 'package:aewallet/ui/views/tokens_list/layouts/components/token_add_btn.dart';
import 'package:aewallet/ui/views/tokens_list/layouts/components/token_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class TokensList extends ConsumerStatefulWidget {
  const TokensList({super.key});

  @override
  ConsumerState<TokensList> createState() => TokensListState();
}

class TokensListState extends ConsumerState<TokensList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String searchCriteria = '';
  late FocusNode _focusNode;
  double _searchFieldWidth = 150;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {
        _searchFieldWidth = MediaQuery.of(context).size.width * 0.9;
      });
    } else {
      setState(() {
        _searchFieldWidth = 150;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final tokens = ref
        .watch(
          tokensProvider(
            searchCriteria: searchCriteria,
            withLPToken: false,
            withNotVerified: false,
          ),
        )
        .valueOrNull;
    final localizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (FeatureFlags.tokenFungibleCreationFeature) TokenAddBtn(),
                CustomTokenAddBtn(),
              ],
            ),
            SizedBox(
              height: 48,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _searchFieldWidth,
                child: TextFormField(
                  focusNode: _focusNode,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    prefixIcon: Icon(
                      Symbols.search,
                      color: ArchethicTheme.text,
                      size: 20,
                      weight: IconSize.weightM,
                      opticalSize: IconSize.opticalSizeM,
                      grade: IconSize.gradeM,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(90),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: AppTextStyles.bodyMedium(context),
                    filled: true,
                    hintText: localizations.searchField,
                  ),
                  style: ArchethicThemeStyles.textStyleSize12W100Primary,
                  textAlign: TextAlign.left,
                  autocorrect: false,
                  cursorColor: ArchethicTheme.text,
                  inputFormatters: <TextInputFormatter>[
                    UpperCaseTextFormatter(),
                  ],
                  onChanged: (text) async {
                    setState(
                      () {
                        searchCriteria = text;
                      },
                    );
                  },
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
              ),
            ),
          ],
        ),
        if (tokens != null)
          Column(
            children: tokens.map((aeToken) {
              return InkWell(
                onTap: () async {
                  await context.push(
                    TokenDetailSheet.routerPage,
                    extra: {
                      'aeToken': aeToken.toJson(),
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: TokenDetail(
                    aeToken: aeToken,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
