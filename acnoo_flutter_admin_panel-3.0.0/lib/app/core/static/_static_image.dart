import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/core/theme/_app_colors.dart';

abstract class AcnooStaticImage {
  static const bannerImage01 =
      'assets/images/widget_images/banner_images/banner_image01.png';
  static const articleIcon =
      'assets/images/widget_images/dashboard_icon/article.svg';

  // Widget Images
  static const featureCardBg =
      'assets/images/widget_images/card_images/feature_card/feature_card_bg.png';

  // Authentication Images
  static const signInCover =
      'assets/images/widget_images/authentication_images/signin_cover.svg';
  static const signUpCover =
      'assets/images/widget_images/authentication_images/signup_cover.svg';
  static const googleIcon =
      'assets/images/widget_images/authentication_images/google_icon.svg';
  static const appleIcon =
      'assets/images/widget_images/authentication_images/apple_icon.svg';
}

abstract class AcnooSVGIcons {
  static const copyIcon = 'assets/images/widget_images/svg_icons/copy_icon.svg';
  static const csvIcon = 'assets/images/widget_images/svg_icons/csv_icon.svg';
  static const excelIcon =
      'assets/images/widget_images/svg_icons/excel_icon.svg';
  static const pdfIcon = 'assets/images/widget_images/svg_icons/pdf_icon.svg';
  static const printIcon =
      'assets/images/widget_images/svg_icons/print_icon.svg';

  static const emailIcon = 'assets/images/sidebar_icons/envelope.svg';
  static const starIcon = 'assets/images/widget_images/svg_icons/star.svg';
  static const sendIcon = 'assets/images/widget_images/svg_icons/send.svg';
  static const editIcon = 'assets/images/widget_images/svg_icons/edit.svg';
  static const infoIcon = 'assets/images/sidebar_icons/exclamation-circle.svg';
  static const trashCanIcon = 'assets/images/widget_images/svg_icons/trash.svg';
  static const galleryIcon =
      'assets/images/widget_images/svg_icons/gallery_icon.svg';

  static const refundsIcon =
      'assets/images/widget_images/svg_icons/refunds.svg';
  static const shopIcon = 'assets/images/widget_images/svg_icons/shop.svg';
  static const tagDollarIcon =
      'assets/images/widget_images/svg_icons/tag_dollar.svg';
  static const usersIcon = 'assets/images/widget_images/svg_icons/users.svg';

  //social icons
  static const SvgImageHolder facebookIcon = (
    svgPath: 'assets/images/static_images/icons/social_icons/facebook.svg',
    baseColor: Color(0xff487FFF)
  );
  static const SvgImageHolder cloudIcon = (
    svgPath: 'assets/images/static_images/icons/social_icons/cloud.svg',
    baseColor: AcnooAppColors.kError
  );
  static const SvgImageHolder sEmailIcon = (
    svgPath: 'assets/images/static_images/icons/social_icons/email.svg',
    baseColor: Color(0xff7500FD)
  );
  static const SvgImageHolder shareIcon = (
    svgPath: 'assets/images/static_images/icons/social_icons/share.svg',
    baseColor: AcnooAppColors.kSuccess
  );
  static const SvgImageHolder telegramIcon = (
    svgPath: 'assets/images/static_images/icons/social_icons/telegram.svg',
    baseColor: Color(0xffFD7F0B)
  );
  //delivery icons
  static const SvgImageHolder orderConfirm = (
    svgPath:
        'assets/images/widget_images/delivery_dashboard_icons/order_confirm.svg',
    baseColor: AcnooAppColors.kSuccess
  );
  static const SvgImageHolder orderPending = (
    svgPath:
        'assets/images/widget_images/delivery_dashboard_icons/order_pending.svg',
    baseColor: Color(0xffFDBA40)
  );
  static const SvgImageHolder orderDelivered = (
    svgPath:
        'assets/images/widget_images/delivery_dashboard_icons/order_delivered.svg',
    baseColor: Color(0xff7500FD)
  );
  static const SvgImageHolder orderCancelled = (
    svgPath:
        'assets/images/widget_images/delivery_dashboard_icons/order_cancelled.svg',
    baseColor: Color(0xffF26944)
  );
}

typedef SvgImageHolder = ({String svgPath, Color? baseColor});
