import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/category/category_add_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/category/category_mod_param.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../models/common/count_vo.dart';
import '../../../../models/shop/category/category.dart';
import '../../../repository/shop/category/category_client.dart';
import '../../../utils/dio_factory.dart';

class CategoryService{
  late CategoryClient client = CategoryClient(DioFactory.createDio());

  //카테고리 단일 조회
  Future<Category> getCategory(int categoryId) async {
    return await client.getCategory(categoryId);
  }

  //카테고리 목록 조회
  Future<List<Category>> getCategoryList(PagingParam pagingParam) async {
    return await client.getCategoryList(pagingParam);
  }

  //카테고리 목록 갯수 조회
  Future<int> getCategoryListCount() async {
    CountVo countVo = await client.getUserListCount();
    return countVo.count;
  }

  //카테고리 추가
  Future<Category> addCategory(CategoryAddParam categoryAddParam) async {
    return await client.addCategory(categoryAddParam);
  }

  //카테고리 변경
  Future<Category> modCategory(int categoryId, CategoryModParam categoryModParam) async {
    return await client.modCategory(categoryId, categoryModParam);
  }

  //카테고리 삭제
  Future<bool> delCategory(int categoryId) async {
    HttpResponse res = await client.delCategory(categoryId);
    return res.response.statusCode == 204;
  }
}