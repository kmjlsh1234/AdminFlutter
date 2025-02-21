import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/board/board_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/file/file_service.dart';
import 'package:acnoo_flutter_admin_panel/app/models/app_version/app_version.dart';
import 'package:acnoo_flutter_admin_panel/app/models/board/board_add_param.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import '../../../generated/l10n.dart' as l;
import '../../constants/board/board_status.dart';
import '../../constants/board/board_type.dart';
import '../../constants/file/file_category.dart';
import '../../constants/file/file_type.dart';
import '../../core/theme/_app_colors.dart';
import '../../core/utils/file_util.dart';
import '../../models/board/board.dart';
import '../../widgets/shadow_container/_shadow_container.dart';

class BoardWriteView extends StatefulWidget {
  const BoardWriteView({super.key});
  @override
  State<BoardWriteView> createState() => _BoardWriteViewState();
}

class _BoardWriteViewState extends State<BoardWriteView> {
  final QuillController controller = QuillController.basic();
  final ScrollController scrollController = ScrollController();
  final TextEditingController titleController = TextEditingController();
  final BoardService boardService = BoardService();
  final FileService fileService = FileService();

  BoardType selectType = BoardType.notice;
  BoardStatus selectStatus = BoardStatus.publish;

  List<String> imageUrls = [];

  //게시판 추가
  Future<void> addBoard() async {
    try{
      //Delta to HTML
      QuillDeltaToHtmlConverter converter = QuillDeltaToHtmlConverter(controller.document.toDelta().toJson(), ConverterOptions.forEmail());
      String html = converter.convert();

      if(imageUrls.isNotEmpty){
        List<String> uploadedImageURLs = [];
        for(String url in imageUrls){
          //TODO : BLOB URL에서 파일 형식으로 변환하기
          Uint8List imageBytes = await FileUtil.fetchBlobImage(url);
          String extension = await FileUtil.getFileExtension(url, imageBytes);
          String filename = "file.$extension";

          MultipartFile multipartFile = MultipartFile.fromBytes(imageBytes, filename: filename);
          FormData formData = FormData.fromMap({"file": multipartFile});

          String savePath = await fileService.uploadFile(FileCategory.profile, FileType.image, formData);
          uploadedImageURLs.add(savePath);
        }

        // TODO: 작성한 게시판 내의 저장한 이미지 경로 AWS경로로 변경
        for (int i = 0; i < imageUrls.length; i++) {
          String localPath = imageUrls[i];
          String remoteUrl = uploadedImageURLs[i];
          html = html.replaceAll(localPath, remoteUrl);
        }
      }

      // TODO: ADMIN서버에 게시판 저장
      BoardAddParam boardAddParam = BoardAddParam(
          title: titleController.text,
          content: html,
          boardType: selectType.value,
          status: selectStatus.value,
          image: null
      );
      Board board = await boardService.addBoard(boardAddParam);
      showAddBoardSuccessDialog(context);
    } catch (e){
      ErrorHandler.handleError(e, context);
    }
  }

  Future<void> selectImage(String image) async{
    imageUrls.add(image);
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 16,
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
            context,
            conditionalValues: [
              const rf.Condition.between(
                start: 0,
                end: 480,
                value: _SizeInfo(
                  alertFontSize: 12,
                  padding: EdgeInsets.all(16),
                  innerSpacing: 16,
                ),
              ),
              const rf.Condition.between(
                start: 481,
                end: 576,
                value: _SizeInfo(
                  alertFontSize: 14,
                  padding: EdgeInsets.all(16),
                  innerSpacing: 16,
                ),
              ),
              const rf.Condition.between(
                start: 577,
                end: 992,
                value: _SizeInfo(
                  alertFontSize: 14,
                  padding: EdgeInsets.all(16),
                  innerSpacing: 16,
                ),
              ),
            ],
            defaultValue: const _SizeInfo(),
          ).value;

          TextTheme textTheme = Theme.of(context).textTheme;
          final theme = Theme.of(context);

          return Scaffold(
            body: Padding(
              padding: _sizeInfo.padding,
              child: ShadowContainer(
                showHeader: false,
                contentPadding: EdgeInsets.zero,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      final isMobile = constraints.maxWidth < 481;
                      final isTablet = constraints.maxWidth < 992 &&
                          constraints.maxWidth >= 481;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: _sizeInfo.padding,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Title',
                                  style: Theme.of(context).textTheme.titleMedium,

                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: searchFormField(textTheme: Theme.of(context).textTheme),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: _sizeInfo.padding,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildStatusCheckbox(BoardStatus.publish),
                                const SizedBox(width: 10),
                                buildStatusCheckbox(BoardStatus.notPublish),
                              ],
                            ),
                          ),
                          Padding(
                            padding: _sizeInfo.padding,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildTypeCheckbox(BoardType.notice),
                                const SizedBox(width: 10),
                                buildTypeCheckbox(BoardType.event),
                              ],
                            ),
                          ),
                          //______________________________________________________________________Header__________________
                          Padding(
                            padding: _sizeInfo.padding,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: QuillToolbar.simple(
                                      controller: controller,
                                      configurations:
                                          QuillSimpleToolbarConfigurations(
                                        embedButtons:
                                            FlutterQuillEmbeds.toolbarButtons(
                                              imageButtonOptions: QuillToolbarImageButtonOptions(
                                                imageButtonConfigurations: QuillToolbarImageConfigurations(
                                                  onImageInsertedCallback: (image) {
                                                    return selectImage(image);
                                                  }
                                                ),
                                              )
                                            )
                                            ),
                                      )
                                ),
                              ],
                            ),
                          ),

                          //______________________________________________________________________QuillEditor__________________
                          Container(height: 16),
                          // 툴바와 에디터 사이 여백 추가
                          Container(
                            padding: EdgeInsets.all(30),
                            height: 1200,
                            child: QuillEditor.basic(
                              controller: controller,
                              configurations: QuillEditorConfigurations(
                                embedBuilders:
                                    FlutterQuillEmbeds.editorWebBuilders(),
                              ),
                            ),
                          ),

                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: _padding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 36,
                                  child: addBoardButton(textTheme, context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void showAddBoardSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text('게시판 추가 성공'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                GoRouter.of(context).go('/boards');
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  Container searchFormField({required TextTheme textTheme}) {
    final lang = l.S.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 1200, minWidth: 230),
      child: TextFormField(
        controller: titleController,
        decoration: InputDecoration(
          isDense: true,
          //hintText: 'Search...',
          hintText: '${lang.search}...',
          hintStyle: textTheme.bodySmall,

        ),
      ),
    );
  }

  ElevatedButton addBoardButton(TextTheme textTheme, BuildContext context) {
    final lang = l.S.of(context);
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {
        addBoard();
      },
      label: Text(
        lang.addNewUser,
        //l.S.of(context).addNewUser,
        //'Add New User',
        maxLines: 1,
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconAlignment: IconAlignment.start,
      icon: const Icon(
        Icons.add_circle_outline_outlined,
        color: AcnooAppColors.kWhiteColor,
        size: 20.0,
      ),
    );
  }

  Widget buildStatusCheckbox(BoardStatus boardStatus) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: selectStatus == boardStatus,
          onChanged: (bool? newValue) {
            if (newValue == true) {
              setState(() {
                selectStatus = boardStatus;
              });
            } else if (selectStatus == boardStatus) {
              setState(() {
                selectStatus = boardStatus; // Deselect if it's the current selected one
              });
            }
          },
        ),
        const SizedBox(width: 4.0),
        Text(boardStatus.value),
      ],
    );
  }

  Widget buildTypeCheckbox(BoardType boardType) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: selectType == boardType,
          onChanged: (bool? newValue) {
            if (newValue == true) {
              setState(() {
                selectType = boardType;
              });
            } else if (selectType == boardType) {
              setState(() {
                selectType = boardType;
              });
            }
          },
        ),
        const SizedBox(width: 4.0),
        Text(boardType.value),
      ],
    );
  }
}

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;

  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}
