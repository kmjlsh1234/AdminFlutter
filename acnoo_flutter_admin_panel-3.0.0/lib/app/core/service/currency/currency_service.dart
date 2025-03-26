import 'package:acnoo_flutter_admin_panel/app/core/repository/currency/currency_repository.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/dio_factory.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/currency/chips.dart';
import '../../../models/currency/coins.dart';
import '../../../models/currency/currency_mod_param.dart';
import '../../../models/currency/diamond_mod_param.dart';
import '../../../models/currency/diamonds.dart';

class CurrencyService{
  late CurrencyRepository repository = CurrencyRepository(DioFactory.createDio());

  Future<Chips> getChip(int userId) async {
    Chips chip = await repository.getChip(userId);
    return chip;
  }

  Future<Coins> getCoin(int userId) async {
    Coins coin = await repository.getCoin(userId);
    return coin;
  }

  Future<Diamonds> getDiamond(int userId) async {
    Diamonds diamond = await repository.getDiamond(userId);
    return diamond;
  }

  Future<bool> modChip(int userId, CurrencyModParam currencyModParam) async {
    HttpResponse result = await repository.modChip(userId, currencyModParam);
    return result.response.statusCode == 200;
  }

  Future<bool> modCoin(int userId, CurrencyModParam currencyModParam) async {
    HttpResponse result = await repository.modCoin(userId, currencyModParam);
    return result.response.statusCode == 200;
  }

  Future<bool> modDiamond(int userId, DiamondModParam diamondModParam) async {
    HttpResponse result = await repository.modDiamond(userId, diamondModParam);
    return result.response.statusCode == 200;
  }
}