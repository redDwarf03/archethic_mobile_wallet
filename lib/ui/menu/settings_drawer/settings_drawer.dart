/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';

import 'package:aewallet/application/account/providers.dart';
// Project imports:
import 'package:aewallet/application/authentication/authentication.dart';
import 'package:aewallet/application/device_abilities.dart';
import 'package:aewallet/application/settings/language.dart';
import 'package:aewallet/application/settings/primary_currency.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/application/settings/theme.dart';
import 'package:aewallet/application/settings/version.dart';
import 'package:aewallet/application/wallet/wallet.dart';
import 'package:aewallet/localization.dart';
import 'package:aewallet/model/authentication_method.dart';
import 'package:aewallet/model/available_currency.dart';
import 'package:aewallet/model/available_language.dart';
import 'package:aewallet/model/available_themes.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:aewallet/model/device_lock_timeout.dart';
import 'package:aewallet/model/device_unlock_option.dart';
import 'package:aewallet/model/primary_currency.dart';
import 'package:aewallet/model/setting_item.dart';
import 'package:aewallet/ui/util/responsive.dart';
import 'package:aewallet/ui/util/styles.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/authenticate/auth_factory.dart';
import 'package:aewallet/ui/views/settings/backupseed_sheet.dart';
import 'package:aewallet/ui/widgets/components/dialog.dart';
import 'package:aewallet/ui/widgets/components/icon_widget.dart';
import 'package:aewallet/ui/widgets/components/icons.dart';
import 'package:aewallet/ui/widgets/components/sheet_util.dart';
import 'package:aewallet/ui/widgets/dialogs/authentification_method_dialog.dart';
import 'package:aewallet/ui/widgets/dialogs/currency_dialog.dart';
import 'package:aewallet/ui/widgets/dialogs/language_dialog.dart';
import 'package:aewallet/ui/widgets/dialogs/lock_dialog.dart';
import 'package:aewallet/ui/widgets/dialogs/lock_timeout_dialog.dart';
import 'package:aewallet/ui/widgets/dialogs/primary_currency_dialog.dart';
import 'package:aewallet/ui/widgets/dialogs/theme_dialog.dart';
import 'package:aewallet/util/case_converter.dart';
import 'package:aewallet/util/get_it_instance.dart';
import 'package:aewallet/util/haptic_util.dart';
import 'package:aewallet/util/mnemonics.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

part 'about_menu_view.dart';
part 'components/settings_list_item.dart';
part 'components/settings_list_item_defaultvalue.dart';
part 'components/settings_list_item_singleline.dart';
part 'components/settings_list_item_switch.dart';
part 'customization_menu_view.dart';
part 'main_settings_view.dart';
part 'security_menu_view.dart';
part 'settings_drawer_wallet.dart';
