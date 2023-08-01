/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/bg_tmpUser.png
  AssetGenImage get bgTmpUser =>
      const AssetGenImage('assets/images/bg_tmpUser.png');

  /// File path: assets/images/bg_userProfile.png
  AssetGenImage get bgUserProfile =>
      const AssetGenImage('assets/images/bg_userProfile.png');

  /// File path: assets/images/ic_bookAlt.png
  AssetGenImage get icBookAlt =>
      const AssetGenImage('assets/images/ic_bookAlt.png');

  /// File path: assets/images/ic_contact_us.png
  AssetGenImage get icContactUs =>
      const AssetGenImage('assets/images/ic_contact_us.png');

  /// File path: assets/images/ic_donation.png
  AssetGenImage get icDonation =>
      const AssetGenImage('assets/images/ic_donation.png');

  /// File path: assets/images/ic_fiveStar.png
  AssetGenImage get icFiveStar =>
      const AssetGenImage('assets/images/ic_fiveStar.png');

  /// File path: assets/images/ic_fourStar.png
  AssetGenImage get icFourStar =>
      const AssetGenImage('assets/images/ic_fourStar.png');

  /// File path: assets/images/ic_home.png
  AssetGenImage get icHome => const AssetGenImage('assets/images/ic_home.png');

  /// File path: assets/images/ic_import_contacts.png
  AssetGenImage get icImportContacts =>
      const AssetGenImage('assets/images/ic_import_contacts.png');

  /// File path: assets/images/ic_language.png
  AssetGenImage get icLanguage =>
      const AssetGenImage('assets/images/ic_language.png');

  /// File path: assets/images/ic_menuButton.png
  AssetGenImage get icMenuButton =>
      const AssetGenImage('assets/images/ic_menuButton.png');

  /// File path: assets/images/ic_oneStar.png
  AssetGenImage get icOneStar =>
      const AssetGenImage('assets/images/ic_oneStar.png');

  /// File path: assets/images/ic_performance.png
  AssetGenImage get icPerformance =>
      const AssetGenImage('assets/images/ic_performance.png');

  /// File path: assets/images/ic_profile.png
  AssetGenImage get icProfile =>
      const AssetGenImage('assets/images/ic_profile.png');

  /// File path: assets/images/ic_report.png
  AssetGenImage get icReport =>
      const AssetGenImage('assets/images/ic_report.png');

  /// File path: assets/images/ic_settings.png
  AssetGenImage get icSettings =>
      const AssetGenImage('assets/images/ic_settings.png');

  /// File path: assets/images/ic_share_feedback.png
  AssetGenImage get icShareFeedback =>
      const AssetGenImage('assets/images/ic_share_feedback.png');

  /// File path: assets/images/ic_side_menu.png
  AssetGenImage get icSideMenu =>
      const AssetGenImage('assets/images/ic_side_menu.png');

  /// File path: assets/images/ic_suggest_remedies.png
  AssetGenImage get icSuggestRemedies =>
      const AssetGenImage('assets/images/ic_suggest_remedies.png');

  /// File path: assets/images/ic_suitcase.png
  AssetGenImage get icSuitcase =>
      const AssetGenImage('assets/images/ic_suitcase.png');

  /// File path: assets/images/ic_threeStar.png
  AssetGenImage get icThreeStar =>
      const AssetGenImage('assets/images/ic_threeStar.png');

  /// File path: assets/images/ic_twoStar.png
  AssetGenImage get icTwoStar =>
      const AssetGenImage('assets/images/ic_twoStar.png');

  /// File path: assets/images/ic_user.png
  AssetGenImage get icUser => const AssetGenImage('assets/images/ic_user.png');

  /// File path: assets/images/ic_wallet.png
  AssetGenImage get icWallet =>
      const AssetGenImage('assets/images/ic_wallet.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        bgTmpUser,
        bgUserProfile,
        icBookAlt,
        icContactUs,
        icDonation,
        icFiveStar,
        icFourStar,
        icHome,
        icImportContacts,
        icLanguage,
        icMenuButton,
        icOneStar,
        icPerformance,
        icProfile,
        icReport,
        icSettings,
        icShareFeedback,
        icSideMenu,
        icSuggestRemedies,
        icSuitcase,
        icThreeStar,
        icTwoStar,
        icUser,
        icWallet
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
