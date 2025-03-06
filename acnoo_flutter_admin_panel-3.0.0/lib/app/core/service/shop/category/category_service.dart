import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/category/category_add_param.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/category/category_mod_param.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../models/common/count_vo.dart';
import '../../../../models/shop/category/category.dart';
import '../../../repository/shop/category/category_repository.dart';
import '../../../utils/dio_factory.dart';

class CategoryService{
  late CategoryRepository repository = CategoryRepository(DioFactory.createDio());

  //카테고리 단일 조회
  Future<Category> getCategory(int categoryId) async {
    return await repository.getCategory(categoryId);
  }

  //카테고리 목록 조회
  Future<List<Category>> getCategoryList(PagingParam pagingParam) async {
    return await repository.getCategoryList(pagingParam);
  }

  //카테고리 목록 갯수 조회
  Future<int> getCategoryListCount() async {
    CountVo countVo = await repository.getUserListCount();
    return countVo.count;
  }

  //카테고리 추가
  Future<Category> addCategory(CategoryAddParam categoryAddParam) async {
    return await repository.addCategory(categoryAddParam);
  }

  //카테고리 변경
  Future<Category> modCategory(int categoryId, CategoryModParam categoryModParam) async {
    return await repository.modCategory(categoryId, categoryModParam);
  }

  //카테고리 삭제
  Future<bool> delCategory(int categoryId) async {
    HttpResponse res = await repository.delCategory(categoryId);
    return res.response.statusCode == 204;
  }
}