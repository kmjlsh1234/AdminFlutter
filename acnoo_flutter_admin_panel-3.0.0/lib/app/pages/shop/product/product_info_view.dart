import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart' as l;
import '../../../core/service/shop/product/product_service.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../models/shop/product/product/product_detail.dart';

class ProductInfoView extends StatefulWidget {
  const ProductInfoView({super.key, required this.productId});
  final int productId;

  @override
  State<ProductInfoView> createState() => _ProductInfoViewState();
}

class _ProductInfoViewState extends State<ProductInfoView> {
  final ScrollController scrollController = ScrollController();
  final ProductService productService = ProductService();
  late Future<ProductDetail> product;

  //상품 상세 조회
  Future<ProductDetail> getProduct() async {
    try{
      return await productService.getProduct(widget.productId);
    } catch(e){
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  @override
  void initState(){
    super.initState();
    product = getProduct();
  }

  @override
  void dispose(){
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final lang = l.S.of(context);

    return FutureBuilder<ProductDetail>(
        future: product,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final product = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16), // 전체 패딩 추가
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        product.image,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 100, color: Colors.grey);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16), // 표 내부 패딩 추가
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildProfileDetailRow(lang.name, product.name, textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.description, product.description, textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.status, product.status, textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.info, product.info, textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.type, product.type, textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.stockQuantity, product.stockQuantity.toString(), textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.price, product.price.toString(), textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.originPrice, product.originPrice.toString(), textTheme),
                        _buildDivider(theme),
                        //TODO: 옵션 넣기
                        buildProfileDetailRow(lang.createdAt, product.createdAt.toString(), textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.updatedAt, product.updatedAt.toString(), textTheme),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Container(
                    color: theme.colorScheme.primaryContainer,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        modProductButton(textTheme, product),
                      ],
                    ),
                  )
                ],
              )
            )
          );
        });
  }

  ElevatedButton modProductButton(TextTheme textTheme, ProductDetail product) {
    final lang = l.S.of(context);
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {
        showModFormDialog(product);
      },
      label: Text(
        lang.modItemUnit,
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      color: theme.colorScheme.outline,
      height: 12.0,
    );
  }

  Widget buildProfileDetailRow(String label, String? value, TextTheme textTheme) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Text(
                  ':',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: Text(
                    value ?? "N/A",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showModFormDialog(ProductDetail product) async {
    bool success = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: Text(''));
      },
    );

    if (success) {
      setState(() {
        this.product = getProduct();
      });
    }
  }
}
