// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/constants/menus/menu/menu_visibility.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/alert_util.dart';
import 'package:acnoo_flutter_admin_panel/app/core/utils/compare_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

// 🌎 Project imports:
import '../../../../../../generated/l10n.dart' as l;
import '../../../../core/error/custom_exception.dart';
import '../../../../core/error/error_code.dart';
import '../../../../core/service/file/file_service.dart';
import '../../../../core/service/menus/menu_service.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/menus/menu/menu.dart';
import '../../../../models/menus/menu/menu_mod_param.dart';
import '../../../../widgets/textfield_wrapper/_textfield_wrapper.dart';
import '../../../common_widget/dotted_borderer_container.dart';
import '../../privilege/component/search_menu_popup.dart';

class ModMenuDialog extends StatefulWidget {
  const ModMenuDialog({super.key, required this.menu});
  final Menu menu;

  @override
  State<ModMenuDialog> createState() => _ModMenuDialogState();
}

class _ModMenuDialogState extends State<ModMenuDialog> {

  //Input Controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController pathController = TextEditingController();
  final TextEditingController parentController = TextEditingController();

  //Service
  final MenuService menuService = MenuService();
  final FileService fileService = FileService();

  //File
  final ImagePicker picker = ImagePicker();
  String? imagePath;
  XFile? imageFile;

  late MenuVisibility menuVisibility;

  //Provider
  late l.S lang;
  late ThemeData theme;
  late TextTheme textTheme;

  //메뉴 변경
  Future<void> modMenu() async {
    try {
      checkModParameter();
      Menu menu = await menuService.modMenu(widget.menu.id, getMenuModParam());
      AlertUtil.successDialog(
          context: context,
          message: lang.successModMenu,
          buttonText: lang.confirm,
          onPressed: (){
            GoRouter.of(context).pop();
            GoRouter.of(context).pop(true);
          }
      );
    } catch (e) {
      ErrorHandler.handleError(e, context);
    }
  }

  void checkModParameter() {
    if(nameController.text.isEmpty) {
      throw CustomException(ErrorCode.PARENT_ADMIN_MENU_NOT_EXIST); //나중에 바꾸기
    }

    if(imagePath == null || imagePath!.isEmpty) {
      throw CustomException(ErrorCode.PARENT_ADMIN_MENU_NOT_EXIST);
    }
  }

  MenuModParam getMenuModParam() {
    return MenuModParam(
        parentId: int.tryParse(parentController.text),
        menuName: CompareUtil.compareStringValue(widget.menu.menuName, nameController.text),
        sortOrder: null,
        menuPath: 'menuPath',
        image: imagePath,
        visibility: (widget.menu.visibility == menuVisibility.value) ? null : menuVisibility
    );
  }

  //이미지 로컬에서 가져오기
  Future<void> pickImage() async {
    try{
      XFile? pickFile = await picker.pickImage(source: ImageSource.gallery);

      if(pickFile == null){
        throw CustomException(ErrorCode.FAIL_TO_CONVERT_FILE);
      }

      setState(() {
        imageFile = pickFile;
        imagePath = pickFile.path;
      });
    } catch (e){
      ErrorHandler.handleError(e, context);
    }
  }

  @override
  void initState(){
    super.initState();
    nameController.text = widget.menu.menuName;
    parentController.text = widget.menu.parentId?.toString() ?? lang.empty;
    pathController.text = widget.menu.menuPath;
    imagePath = widget.menu.image;
    menuVisibility = widget.menu.visibility;
   }

  @override
  void dispose(){
    nameController.dispose();
    parentController.dispose();
    pathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _sizeInfo = SizeConfig.getSizeInfo(context);
    lang = l.S.of(context);
    theme = Theme.of(context);
    textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///---------------- header section
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lang.modMenu),
                  IconButton(
                    onPressed: () => GoRouter.of(context).pop(false),
                    icon: const Icon(
                      Icons.close,
                      color: AcnooAppColors.kError,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 0.1,
              color: theme.colorScheme.outline,
              height: 0,
            ),

            ///---------------- header section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 606,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Image
                    TextFieldLabelWrapper(
                      labelText: lang.image,
                      inputField: DottedBorderContainer(
                        child: GestureDetector(
                          onTap: () => pickImage(),
                          child: imagePath == null
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                color: theme.colorScheme.onTertiary,
                              ),
                              Text(lang.uploadImage),
                            ],
                          ) : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SvgPicture.network(
                                imagePath!,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              )
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    ///---------------- Text Field section

                    //NAME
                    TextFieldLabelWrapper(
                      labelText: lang.name,
                      inputField: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            hintText: lang.hintName,
                            hintStyle: textTheme.bodySmall),
                        validator: (value) => value?.isEmpty ?? true ? lang.invalidName : null,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                      ),
                    ),

                    const SizedBox(height: 20),

                    //PARENT MENU
                    TextFieldLabelWrapper(
                      labelText: lang.parentMenuId,
                      inputField: TextFormField(
                        readOnly: true,
                        controller: parentController,
                        decoration: InputDecoration(
                          hintText: lang.search,
                          filled: true,
                          fillColor: theme.colorScheme.tertiaryContainer,
                          suffixIcon: IconButton(
                            icon: Icon(
                                Icons.search,
                                color: theme.colorScheme.primary
                            ),
                            onPressed: () {
                              showSearchDialog();
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    //PATH
                    TextFieldLabelWrapper(
                        labelText: lang.path,
                        inputField: TextFormField(
                          controller: pathController,
                          decoration: InputDecoration(
                              hintText: lang.hintPath,
                              hintStyle: textTheme.bodySmall),
                          validator: (value) => value?.isEmpty ?? true ? lang.invalidPath : null,
                          autovalidateMode: AutovalidateMode.onUnfocus,
                        ),
                    ),

                    const SizedBox(height: 20),

                    //Visibility
                    TextFieldLabelWrapper(
                      labelText: lang.visibility,
                      inputField: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildCheckbox(MenuVisibility.VISIBLE),
                          const SizedBox(width: 10),
                          _buildCheckbox(MenuVisibility.INVISIBLE),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    ///---------------- Submit Button section
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: _sizeInfo.innerSpacing),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: _sizeInfo.innerSpacing),
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                textStyle: textTheme.bodySmall
                                    ?.copyWith(color: AcnooAppColors.kError),
                                side: const BorderSide(
                                    color: AcnooAppColors.kError)),
                            onPressed: () => GoRouter.of(context).pop(false),
                            label: Text(
                              lang.cancel,
                              //'Cancel',
                              style: textTheme.bodySmall
                                  ?.copyWith(color: AcnooAppColors.kError),
                            ),
                          ),
                          SizedBox(width: _sizeInfo.innerSpacing),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: _sizeInfo.innerSpacing),
                            ),
                            onPressed: () => modMenu(),
                            //label: const Text('Save'),
                            label: Text(lang.save),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(MenuVisibility visibility) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: menuVisibility == visibility,
          onChanged: (bool? newValue) {
            if (newValue == true) {
              setState(() {
                menuVisibility = visibility;
              });
            }
          },
        ),
        const SizedBox(width: 4.0),
        Text(visibility.value),
      ],
    );
  }

  void showSearchDialog() async {
    Menu? menu = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SearchMenuDialog();
      },
    );

    if (menu != null) {
      setState(() {
        parentController.text = menu.id.toString();
      });
    }
  }
}

