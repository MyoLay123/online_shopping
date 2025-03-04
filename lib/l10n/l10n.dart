import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/product_localizations.dart';
import 'package:flutter_gen/gen_l10n/welcome_localizations.dart';

export 'package:flutter_gen/gen_l10n/product_localizations.dart';
export 'package:flutter_gen/gen_l10n/welcome_localizations.dart';

extension AppLocalizationsX on BuildContext {
  ProductLocalizations get productL10n => ProductLocalizations.of(this)!;
  WelcomeLocalizations get welcomeL10n => WelcomeLocalizations.of(this)!;
}
