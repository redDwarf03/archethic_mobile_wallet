// @dart=2.9

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:event_taxi/event_taxi.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// Project imports:
import 'package:uniris_mobile_wallet/appstate_container.dart';
import 'package:uniris_mobile_wallet/bus/events.dart';
import 'package:uniris_mobile_wallet/dimens.dart';
import 'package:uniris_mobile_wallet/localization.dart';
import 'package:uniris_mobile_wallet/model/db/account.dart';
import 'package:uniris_mobile_wallet/model/db/appdb.dart';
import 'package:uniris_mobile_wallet/service_locator.dart';
import 'package:uniris_mobile_wallet/styles.dart';
import 'package:uniris_mobile_wallet/ui/accounts/accountdetails_sheet.dart';
import 'package:uniris_mobile_wallet/ui/util/ui_util.dart';
import 'package:uniris_mobile_wallet/ui/widgets/buttons.dart';
import 'package:uniris_mobile_wallet/ui/widgets/dialog.dart';
import 'package:uniris_mobile_wallet/ui/widgets/sheets.dart';
import 'package:uniris_mobile_wallet/util/caseconverter.dart';
import 'package:uniris_mobile_wallet/util/numberutil.dart';

class AppAccountsSheet {
  AppAccountsSheet(this.accounts);

  List<Account> accounts;

  mainBottomSheet(BuildContext context) {
    AppSheets.showAppHeightNineSheet(
        context: context,
        builder: (BuildContext context) {
          return AppAccountsWidget(accounts: accounts);
        });
  }
}

class AppAccountsWidget extends StatefulWidget {
  final List<Account> accounts;

  const AppAccountsWidget({Key key, @required this.accounts}) : super(key: key);

  @override
  _AppAccountsWidgetState createState() => _AppAccountsWidgetState();
}

class _AppAccountsWidgetState extends State<AppAccountsWidget> {
  static const int MAX_ACCOUNTS = 50;
  final GlobalKey expandedKey = GlobalKey();

  bool _addingAccount;

  final ScrollController _scrollController = ScrollController();

  StreamSubscription<AccountModifiedEvent> _accountModifiedSub;

  bool _accountIsChanging;

  @override
  void initState() {
    super.initState();
    _registerBus();
    _addingAccount = false;
    _accountIsChanging = false;
  }

  @override
  void dispose() {
    _destroyBus();
    super.dispose();
  }

  void _registerBus() {
    _accountModifiedSub = EventTaxiImpl.singleton()
        .registerTo<AccountModifiedEvent>()
        .listen((AccountModifiedEvent event) {
      if (event.deleted) {
        if (event.account.selected) {
          Future.delayed(const Duration(milliseconds: 50), () {
            setState(() {
              widget.accounts
                  .where((Account a) =>
                      a.index ==
                      StateContainer.of(context).selectedAccount.index)
                  .forEach((Account account) {
                account.selected = true;
              });
            });
          });
        }
        setState(() {
          widget.accounts
              .removeWhere((Account a) => a.index == event.account.index);
        });
      } else {
        // Name change
        setState(() {
          widget.accounts
              .removeWhere((Account a) => a.index == event.account.index);
          widget.accounts.add(event.account);
          widget.accounts
              .sort((Account a, Account b) => a.index.compareTo(b.index));
        });
      }
    });
  }

  void _destroyBus() {
    if (_accountModifiedSub != null) {
      _accountModifiedSub.cancel();
    }
  }

  Future<void> _changeAccount(Account account, StateSetter setState) async {
    // Change account
    for (Account a in widget.accounts) {
      if (a.selected) {
        setState(() {
          a.selected = false;
        });
      } else if (account.index == a.index) {
        setState(() {
          a.selected = true;
        });
      }
    }

    await sl.get<DBHelper>().changeAccount(account);
    EventTaxiImpl.singleton()
        .fire(AccountChangedEvent(account: account, delayPop: true));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        minimum: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.035,
        ),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    width: 60,
                    height: 40,
                  ),
                  Column(
                    children: <Widget>[
                      // Sheet handle
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 5,
                        width: MediaQuery.of(context).size.width * 0.15,
                        decoration: BoxDecoration(
                          color: StateContainer.of(context).curTheme.text10,
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                    ],
                  ), // Empty SizedBox
                  const SizedBox(
                    width: 60,
                    height: 40,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //A container for the header
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 140),
                    child: AutoSizeText(
                      CaseChange.toUpperCase(
                          AppLocalization.of(context).accounts, context),
                      style: AppStyles.textStyleHeader(context),
                      maxLines: 1,
                      stepGranularity: 0.1,
                    ),
                  ),
                ],
              ),
              //A list containing accounts
              Expanded(
                  key: expandedKey,
                  child: Stack(
                    children: <Widget>[
                      if (widget.accounts == null)
                        const Center(
                          child: Text('Loading'),
                        )
                      else
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          itemCount: widget.accounts.length,
                          controller: _scrollController,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildAccountListItem(
                                context, widget.accounts[index], setState);
                          },
                        ),
                      //List Top Gradient
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 20.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                StateContainer.of(context)
                                    .curTheme
                                    .backgroundDark00,
                                StateContainer.of(context)
                                    .curTheme
                                    .backgroundDark,
                              ],
                              begin: const AlignmentDirectional(0.5, 1.0),
                              end: const AlignmentDirectional(0.5, -1.0),
                            ),
                          ),
                        ),
                      ),
                      // List Bottom Gradient
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 20.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                StateContainer.of(context)
                                    .curTheme
                                    .backgroundDark,
                                StateContainer.of(context)
                                    .curTheme
                                    .backgroundDark00
                              ],
                              begin: const AlignmentDirectional(0.5, 1.0),
                              end: const AlignmentDirectional(0.5, -1.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 15,
              ),
              //A row with Add Account button
              Row(
                children: <Widget>[
                  if (widget.accounts == null ||
                      widget.accounts.length >= MAX_ACCOUNTS)
                    const SizedBox()
                  else
                    AppButton.buildAppButton(
                      context,
                      AppButtonType.PRIMARY,
                      AppLocalization.of(context).addAccount,
                      Dimens.BUTTON_TOP_DIMENS,
                      disabled: _addingAccount,
                      onPressed: () {
                        if (!_addingAccount) {
                          setState(() {
                            _addingAccount = true;
                          });
                          StateContainer.of(context)
                              .getSeed()
                              .then((String seed) {
                            sl
                                .get<DBHelper>()
                                .addAccount(seed,
                                    nameBuilder: AppLocalization.of(context)
                                        .defaultNewAccountName)
                                .then((Account newAccount) {
                              StateContainer.of(context)
                                  .updateRecentlyUsedAccounts();
                              widget.accounts.add(newAccount);
                              setState(() {
                                _addingAccount = false;
                                widget.accounts.sort((Account a, Account b) =>
                                    a.index.compareTo(b.index));
                                // Scroll if list is full
                                if (expandedKey.currentContext != null) {
                                  final RenderBox box = expandedKey
                                      .currentContext
                                      .findRenderObject();
                                  if (widget.accounts.length * 72.0 >=
                                      box.size.height) {
                                    _scrollController.animateTo(
                                      newAccount.index * 72.0 >
                                              _scrollController
                                                  .position.maxScrollExtent
                                          ? _scrollController
                                                  .position.maxScrollExtent +
                                              72.0
                                          : newAccount.index * 72.0,
                                      curve: Curves.easeOut,
                                      duration:
                                          const Duration(milliseconds: 200),
                                    );
                                  }
                                }
                              });
                            });
                          });
                        }
                      },
                    ),
                ],
              ),
              //A row with Close button
              Row(
                children: <Widget>[
                  AppButton.buildAppButton(
                    context,
                    AppButtonType.PRIMARY_OUTLINE,
                    AppLocalization.of(context).close,
                    Dimens.BUTTON_BOTTOM_DIMENS,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildAccountListItem(
      BuildContext context, Account account, StateSetter setState) {
    return Slidable(
      key: Key(account.id.toString()),
      secondaryActions: _getSlideActionsForAccount(context, account, setState),
      actionExtentRatio: 0.2,
      actionPane: const SlidableStrechActionPane(),
      child: TextButton(
          onPressed: () {
            if (!_accountIsChanging) {
              // Change account
              if (!account.selected) {
                setState(() {
                  _accountIsChanging = true;
                });
                _changeAccount(account, setState);
              }
            }
          },
          child: Column(
            children: <Widget>[
              Divider(
                height: 2,
                color: StateContainer.of(context).curTheme.text15,
              ),
              Container(
                height: 70.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Selected indicator
                    Container(
                      height: 70,
                      width: 6,
                      color: account.selected
                          ? StateContainer.of(context).curTheme.primary
                          : Colors.transparent,
                    ),
                    // Icon, Account Name, Address and Amount
                    Expanded(
                      child: Container(
                        margin:
                            const EdgeInsetsDirectional.only(start: 8, end: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 64.0,
                                  height: 64.0,
                                  child: CircleAvatar(
                                    backgroundColor: StateContainer.of(context)
                                        .curTheme
                                        .text05,
                                    backgroundImage: NetworkImage(
                                        UIUtil.getRobohashURL(account.address)),
                                    radius: 50.0,
                                  ),
                                ),
                                // Account name and address
                                Container(
                                  width: (MediaQuery.of(context).size.width -
                                          116) *
                                      0.5,
                                  margin: const EdgeInsetsDirectional.only(
                                      start: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      // Account name
                                      AutoSizeText(
                                        account.name,
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.0,
                                          color: StateContainer.of(context)
                                              .curTheme
                                              .text,
                                        ),
                                        minFontSize: 8.0,
                                        stepGranularity: 0.1,
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                      ),
                                      // Account address
                                      AutoSizeText(
                                        account.address.substring(0, 12) +
                                            '...',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w100,
                                          fontSize: 14.0,
                                          color: StateContainer.of(context)
                                              .curTheme
                                              .text60,
                                        ),
                                        minFontSize: 8.0,
                                        stepGranularity: 0.1,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: (MediaQuery.of(context).size.width - 116) *
                                  0.4,
                              alignment: const AlignmentDirectional(1, 0),
                              child: AutoSizeText.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    // Main balance text
                                    TextSpan(
                                      text: account.balance == null
                                          ? ''
                                          : NumberUtil.getRawAsUsableString(
                                                  account.balance) +
                                              ' UCO',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w900,
                                          color: StateContainer.of(context)
                                              .curTheme
                                              .text),
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                style: const TextStyle(fontSize: 16.0),
                                stepGranularity: 0.1,
                                minFontSize: 1,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Selected indicator
                    Container(
                      height: 70,
                      width: 6,
                      color: account.selected
                          ? StateContainer.of(context).curTheme.primary
                          : Colors.transparent,
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  List<Widget> _getSlideActionsForAccount(
      BuildContext context, Account account, StateSetter setState) {
    final List<Widget> _actions = List<Widget>.empty(growable: true);
    _actions.add(SlideAction(
        child: Container(
          margin: const EdgeInsetsDirectional.only(start: 2, top: 1, bottom: 1),
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            color: StateContainer.of(context).curTheme.primary,
          ),
          child: Icon(
            Icons.edit,
            color: StateContainer.of(context).curTheme.backgroundDark,
          ),
        ),
        onTap: () {
          AccountDetailsSheet(account).mainBottomSheet(context);
        }));
    if (account.index > 0) {
      _actions.add(SlideAction(
          child: Container(
            margin:
                const EdgeInsetsDirectional.only(start: 2, top: 1, bottom: 1),
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
              color: StateContainer.of(context).curTheme.primary,
            ),
            child: Icon(
              Icons.delete,
              color: StateContainer.of(context).curTheme.backgroundDark,
            ),
          ),
          onTap: () {
            AppDialogs.showConfirmDialog(
                context,
                AppLocalization.of(context).hideAccountHeader,
                AppLocalization.of(context)
                    .removeAccountText
                    .replaceAll('%1', AppLocalization.of(context).addAccount),
                CaseChange.toUpperCase(
                    AppLocalization.of(context).yes, context), () {
              // Remove account
              sl.get<DBHelper>().deleteAccount(account).then((int id) {
                EventTaxiImpl.singleton().fire(
                    AccountModifiedEvent(account: account, deleted: true));
                setState(() {
                  widget.accounts
                      .removeWhere((Account a) => a.index == account.index);
                });
              });
            },
                cancelText: CaseChange.toUpperCase(
                    AppLocalization.of(context).no, context));
          }));
    }
    return _actions;
  }
}
