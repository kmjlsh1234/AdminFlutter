import 'package:acnoo_flutter_admin_panel/app/models/shop/bundle/bundle/bundle.dart';

enum BundleStatus {
  none('NONE'),
  ready('READY'),
  onSale('ON_SALE'),
  stopSelling('STOP_SELLING'),
  removed('REMOVED'),
  ;
  final String value;

  const BundleStatus(this.value);

  static BundleStatus fromValue(String value) {
    return BundleStatus.values.firstWhere((type) => type.value == value,
      orElse: () => throw ArgumentError("Invalid BundleStatus: $value"),
    );
  }
}