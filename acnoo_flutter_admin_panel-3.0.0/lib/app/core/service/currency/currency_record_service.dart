import '../../../models/common/count_vo.dart';
import '../../../models/currency/chip_record.dart';
import '../../../models/currency/coin_record.dart';
import '../../../models/currency/currency_record_search_param.dart';
import '../../../models/currency/diamond_record.dart';
import '../../repository/currency/currency_record_repository.dart';
import '../../utils/dio_factory.dart';

class CurrencyRecordService{
  late CurrencyRecordRepository repository = CurrencyRecordRepository(DioFactory.createDio());

  //칩 기록 리스트 조회
  Future<List<ChipRecord>> getChipRecordList(CurrencyRecordSearchParam currencyRecordSearchParam) async{
    return await repository.getChipRecordList(currencyRecordSearchParam);
  }

  //칩 기록 리스트 갯수 조회
  Future<int> getChipRecordListCount(CurrencyRecordSearchParam currencyRecordSearchParam) async {
    CountVo countVo = await repository.getChipRecordListCount(currencyRecordSearchParam);
    return countVo.count;
  }

  //코인 기록 리스트 조회
  Future<List<CoinRecord>> getCoinRecordList(CurrencyRecordSearchParam currencyRecordSearchParam) async{
    return await repository.getCoinRecordList(currencyRecordSearchParam);
  }

  //코인 기록 리스트 갯수 조회
  Future<int> getCoinRecordListCount(CurrencyRecordSearchParam currencyRecordSearchParam) async {
    CountVo countVo = await repository.getCoinRecordListCount(currencyRecordSearchParam);
    return countVo.count;
  }

  //다이아 기록 리스트 조회
  Future<List<DiamondRecord>> getDiamondRecordList(CurrencyRecordSearchParam currencyRecordSearchParam) async{
    return await repository.getDiamondRecordList(currencyRecordSearchParam);
  }

  //다이아 기록 리스트 갯수 조회
  Future<int> getDiamondRecordListCount(CurrencyRecordSearchParam currencyRecordSearchParam) async {
    CountVo countVo = await repository.getDiamondRecordListCount(currencyRecordSearchParam);
    return countVo.count;
  }

}