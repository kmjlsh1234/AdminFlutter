import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/board/board_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/file/file_service.dart';
import 'package:acnoo_flutter_admin_panel/app/models/board/board_add_param.dart';
import 'package:acnoo_flutter_admin_panel/app/widgets/textfield_wrapper/_textfield_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import '../../../generated/l10n.dart' as l;
import '../../constants/board/board_status.dart';
import '../../constants/board/board_type.dart';
import '../../constants/file/file_category.dart';
import '../../constants/file/file_type.dart';
import '../../core/error/error_code.dart';
import '../../core/utils/alert_util.dart';
import '../../core/utils/file_util.dart';
import '../../core/utils/size_config.dart';
import '../../models/board/board.dart';
import '../../widgets/shadow_container/_shadow_container.dart';
import '../common_widget/custom_button.dart';

class BoardWriteView extends StatefulWidget {
  const BoardWriteView({super.key});
  @override
  State<BoardWriteView> createState() => _BoardWriteViewState();
}

class _BoardWriteViewState extends State<BoardWriteView> {
  final QuillController controller = QuillController.basic();
  final TextEditingController titleController = TextEditingController();

  final BoardService boardService = BoardService();
  final FileService fileService = FileService();

  BoardType selectType = BoardType.NOTICE;
  BoardStatus selectStatus = BoardStatus.PUBLISH;
  List<String> imageUrls = [];

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //게시판 추가
  Future<void> addBoard() async {
    try{
      //TODO : 파라미터 체크
      checkParameter();

      //TODO : QUILL의 Delta형식을 HTML 형식으로 변환
      QuillDeltaToHtmlConverter converter = QuillDeltaToHtmlConverter(controller.document.toDelta().toJson(), ConverterOptions.forEmail());
      String html = converter.convert();

      //TODO : 이미지를 삽입했다면 BLOB URL형식에서 파일형식으로 변환
      if(imageUrls.isNotEmpty){
        List<String> uploadedImageURLs = [];
        for(String url in imageUrls){
          Uint8List imageBytes = await FileUtil.fetchBlobImage(url);
          XFile file = XFile.fromData(imageBytes);

          String savePath = await fileService.uploadFileTest(file, FileCategory.PROFILE, FileType.IMAGE);
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
      Board board = await boardService.addBoard(getBoardAddParam(html));
      AlertUtil.successDialog(
          context: context,
          message: lang.successAddBoard,
          buttonText: lang.confirm,
          onPressed: (){
            GoRouter.of(context).pop();
            GoRouter.of(context).go('/boards/board-list');
          });
    } catch (e){
      ErrorHandler.handleError(e, context);
    }
  }

  BoardAddParam getBoardAddParam(String html){
    return BoardAddParam(
        title: titleController.text,
        content: html,
        boardType: selectType,
        status: selectStatus
    );
  }

  void checkParameter(){
    if(titleController.text.isEmpty){
      throw CustomException(ErrorCode.BOARD_TITLE_EMPTY);
    }

    if(controller.document.isEmpty()){
      throw CustomException(ErrorCode.BOARD_CONTENT_EMPTY);
    }
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lang = l.S.of(context);
    theme = Theme.of(context);
    textTheme = Theme.of(context).textTheme;
    final _sizeInfo = SizeConfig.getSizeInfo(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Scaffold(
            body: Padding(
              padding: _sizeInfo.padding,
              child: ShadowContainer(
                showHeader: false,
                contentPadding: EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: _sizeInfo.padding,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //TITLE
                          Expanded(
                            flex: 1,
                            child: TextFieldLabelWrapper(
                                labelText: lang.title,
                                inputField: TextFormField(
                                  controller: titleController,
                                  decoration: InputDecoration(
                                      hintText: lang.hintTitle,
                                      hintStyle: textTheme.bodySmall
                                  ),
                                  validator: (value) => value?.isEmpty ?? true ? lang.invalidTitle : null,
                                  autovalidateMode: AutovalidateMode.onUnfocus,
                                ),
                              ),
                          ),
                          const SizedBox(width: 16.0),

                          Spacer(flex: 2),
                          CustomButton(
                              textTheme: textTheme,
                              label: lang.addNewBoard,
                              onPressed: () => addBoard()
                          ),
                        ],
                      ),
                    ),

                    //PUBLISH
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

                    //BOARD TYPE
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

                    //QUILL TOOL BAR
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
                                            onImageInsertedCallback: (image) async => imageUrls.add(image),
                                          ),
                                        )
                                    )
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /*
                          Padding(
                            padding: _sizeInfo.padding,
                            child: TextFieldLabelWrapper(
                              labelText: lang.title,
                              inputField: TextFormField(
                                controller: titleController,
                                decoration: InputDecoration(
                                    hintText: lang.hintTitle,
                                    hintStyle: textTheme.bodySmall
                                ),
                                validator: (value) => value?.isEmpty ?? true ? lang.invalidTitle : null,
                                autovalidateMode: AutovalidateMode.onUnfocus,
                              ),
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
                                                  onImageInsertedCallback: (image) async => imageUrls.add(image),
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
                           */

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
                                ],
                              );
                            },
                          ),
                        ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
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
