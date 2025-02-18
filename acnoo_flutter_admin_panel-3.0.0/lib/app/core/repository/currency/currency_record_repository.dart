import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/common/count_vo.dart';
import '../../../models/currency/chip_record.dart';
import '../../../models/currency/coin_record.dart';
import '../../../models/currency/currency_record_search_param.dart';
import '../../../models/currency/diamond_record.dart';
import '../../app_config/server_config.dart';

part 'currency_record_repository.g.dart';

@RestApi(baseUrl: ServerConfig.baseUrl)
abstract class CurrencyRecordRepository{
  factory CurrencyRecordRepository(Dio dio, {String baseUrl}) = _CurrencyRecordRepository;

  //칩 기록 리스트 조회
  @POST('/admin/v1/chip/records/list')
  Future<List<ChipRecord>> getChipRecordList(@Body() CurrencyRecordSearchParam currencySearchParam);

  //칩 기록 리스트 갯수 조회
  @POST('/admin/v1/chip/records/list/count')
  Future<CountVo> getChipRecordListCount(@Body() CurrencyRecordSearchParam currencySearchParam);

  //코인 기록 리스트 조회
  @POST('/admin/v1/coin/records/list')
  Future<List<CoinRecord>> getCoinRecordList(@Body() CurrencyRecordSearchParam currencySearchParam);

  //코인 기록 리스트 갯수 조회
  @POST('/admin/v1/coin/records/list/count')
  Future<CountVo> getCoinRecordListCount(@Body() CurrencyRecordSearchParam currencySearchParam);

  //칩 기록 리스트 조회
  @POST('/admin/v1/diamond/records/list')
  Future<List<DiamondRecord>> getDiamondRecordList(@Body() CurrencyRecordSearchParam currencySearchParam);

  //칩 기록 리스트 갯수 조회
  @POST('/admin/v1/diamond/records/list/count')
  Future<CountVo> getDiamondRecordListCount(@Body() CurrencyRecordSearchParam currencySearchParam);

}