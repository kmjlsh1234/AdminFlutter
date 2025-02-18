import 'package:acnoo_flutter_admin_panel/app/core/repository/currency/currency_repository.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/dio_factory.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/currency/chip.dart';
import '../../../models/currency/coin.dart';
import '../../../models/currency/currency_mod_param.dart';
import '../../../models/currency/diamond.dart';

class CurrencyService{
  late CurrencyRepository repository = CurrencyRepository(DioFactory.createDio());

  Future<int> getChip(int userId) async {
    Chip chip = await repository.getChip(userId);
    return chip.amount;
  }

  Future<int> getCoin(int userId) async {
    Coin coin = await repository.getCoin(userId);
    return coin.amount;
  }

  Future<int> getDiamond(int userId) async {
    Diamond diamond = await repository.getDiamond(userId);
    return diamond.amount;
  }

  Future<bool> modChip(int userId, CurrencyModParam currencyModParam) async {
    HttpResponse result = await repository.modChip(userId, currencyModParam);
    return result.response.statusCode == 200;
  }

  Future<bool> modCoin(int userId, CurrencyModParam currencyModParam) async {
    HttpResponse result = await repository.modCoin(userId, currencyModParam);
    return result.response.statusCode == 200;
  }

  Future<bool> modDiamond(int userId, CurrencyModParam currencyModParam) async {
    HttpResponse result = await repository.modDiamond(userId, currencyModParam);
    return result.response.statusCode == 200;
  }
}