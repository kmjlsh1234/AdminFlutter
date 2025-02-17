import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/currency/chip.dart';
import '../../../models/currency/coin.dart';
import '../../../models/currency/currency_mod_param.dart';
import '../../../models/currency/diamond.dart';
import '../../app_config/server_config.dart';

part 'currency_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class CurrencyRepository {
  factory CurrencyRepository(Dio dio, {String baseUrl}) = _CurrencyRepository;

  //칩 조회
  @GET('/admin/v1/users/{userId}/chips')
  Future<Chip> getChip(@Path('userId') int userId);

  //코인 조회
  @GET('/admin/v1/users/{userId}/coins')
  Future<Coin> getCoin(@Path('userId') int userId);

  //다이아 조회
  @GET('/admin/v1/users/{userId}/diamonds')
  Future<Diamond> getDiamond(@Path('userId') int userId);

  //칩 변경
  @PUT('/admin/v1/users/{userId}/chips')
  Future<HttpResponse> modChip(@Path('userId') int userId, @Body() CurrencyModParam currencyModParam);

  //코인 변경
  @PUT('/admin/v1/users/{userId}/coins')
  Future<HttpResponse> modCoin(@Path('userId') int userId, @Body() CurrencyModParam currencyModParam);

  //다이아 변경
  @PUT('/admin/v1/users/{userId}/diamonds')
  Future<HttpResponse> modDiamond(@Path('userId') int userId, @Body() CurrencyModParam currencyModParam);
}