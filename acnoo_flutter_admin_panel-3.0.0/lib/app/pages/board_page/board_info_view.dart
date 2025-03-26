import 'dart:developer';

import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/board/board_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/file/file_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../generated/l10n.dart' as l;
import '../../constants/board/board_status.dart';
import '../../constants/board/board_type.dart';
import '../../core/theme/_app_colors.dart';
import '../../core/utils/size_config.dart';
import '../../models/board/board.dart';
import '../../widgets/shadow_container/_shadow_container.dart';

class BoardInfoView extends StatefulWidget {
  const BoardInfoView({super.key, required this.boardId});
  final int boardId;
  @override
  State<BoardInfoView> createState() => _BoardInfoViewState();
}

class _BoardInfoViewState extends State<BoardInfoView> {
  final QuillController _controller = QuillController.basic();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController titleController = TextEditingController();
  final BoardService boardService = BoardService();
  final FileService fileService = FileService();

  //SearchType
  BoardType selectType = BoardType.NOTICE;
  BoardStatus selectStatus = BoardStatus.PUBLISH;

  List<String> imageFiles = [];
  late Board board;
  bool isLoading = true;

  //게시판 단일 조회
  Future<void> getBoard() async {
    try{
      setState(() => isLoading = true);
      Board board = await boardService.getBoard(widget.boardId);
      this.board = board;
      log(board.content.toString());
      Delta delta = HtmlToDelta().convert(board.content);
      _controller.document = Document.fromDelta(delta);
      titleController.text = board.title;
    } catch(e){
      ErrorHandler.handleError(e, context);
    }
    setState(() => isLoading = false);
  }


  Future<void> selectImage(String image) async{
    imageFiles.add(image);
  }

  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
    _scrollController.dispose();
  }

  @override
  void initState(){
    super.initState();
    getBoard();
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

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final _sizeInfo = SizeConfig.getSizeInfo(context);
          TextTheme textTheme = Theme.of(context).textTheme;

          return Scaffold(
            body: Padding(
              padding: _sizeInfo.padding,
              child: ShadowContainer(
                showHeader: false,
                contentPadding: EdgeInsets.zero,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
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
                                buildStatusCheckbox(BoardStatus.PUBLISH),
                                const SizedBox(width: 10),
                                buildStatusCheckbox(BoardStatus.NOT_PUBLISH),
                              ],
                            ),
                          ),
                          Padding(
                            padding: _sizeInfo.padding,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildTypeCheckbox(BoardType.NOTICE),
                                const SizedBox(width: 10),
                                buildTypeCheckbox(BoardType.EVENT),
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
                                      controller: _controller,
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
                              controller: _controller,
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
                selectType = boardType; // Deselect if it's the current selected one
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
