part of '_topbar.dart';

class UserProfileAvatar extends StatelessWidget {
  const UserProfileAvatar({super.key, required this.adminService});

  final AdminService adminService;

  //로그아웃
  Future<void> logout(BuildContext context) async {
    try{
      bool isSuccess = await adminService.logout();
      if(isSuccess){
        GoRouter.of(context).go('/authentication/signin');
      } else{
        throw CustomException(ErrorCode.UNKNOWN_ERROR);
      }
    } catch (e){
      ErrorHandler.handleError(e, context);
    }
  }

  //유저 프로필 조회
  Future<void> showProfile(BuildContext context) async {
    try{
      Admin admin = await adminService.getAdmin();
      showProfileDialog(context, admin);
    } catch (e){
      ErrorHandler.handleError(e, context);
    }
  }

  void showProfileDialog(BuildContext context, Admin admin){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: AdminProfileDialog(admin: admin));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);

    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(60),
      child: DropdownButton2(
        underline: const SizedBox.shrink(),
        customButton: _buildButton(context),
        dropdownStyleData: _dropdownStyle.dropdownStyle.copyWith(
          width: responsiveValue<double>(
            context,
            xs: 200,
            md: 246,
          ),
          maxHeight: 425,
          offset: const Offset(0, -24),
          scrollbarTheme: _theme.scrollbarTheme.copyWith(
            thumbVisibility: WidgetStateProperty.all<bool>(false),
            trackVisibility: WidgetStateProperty.all<bool>(false),
          ),
        ),
        menuItemStyleData: _dropdownStyle.menuItemStyle.copyWith(
          customHeights: [60, 48, 48],
          padding: EdgeInsets.zero,
        ),
        items: [
          // Profile Tile
          DropdownMenuItem<String>(
            value: 'user_profile',
            child: _DropdownItemWrapper(
              child: ListTile(
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
                contentPadding: EdgeInsets.zero,
                title: const Text('Shahidul Islam'),
                titleTextStyle: _theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                subtitle: const Text('Admin'),
                subtitleTextStyle: _theme.textTheme.bodyMedium?.copyWith(
                  color: _theme.colorScheme.onTertiaryContainer,
                ),
              ),
            ),
          ),

          ...{
            "Profile": FeatherIcons.user,
            "Logout": FeatherIcons.power,
          }.entries.toList().asMap().entries.map((item) {
            return DropdownMenuItem(
              value: item.key,
              child: Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: _DropdownItemWrapper(
                  child: ListTile(
                    key: ValueKey(item.value),
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(item.value.value, size: 20),
                    title: Text(item.value.key),
                    titleTextStyle: _theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: _theme.colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ),
            );
          })
        ],
        onChanged: (value) {
          switch(value){
            case 0: //PROFILE
              showProfile(context);
              break;
            case 1: //LOGOUT
              logout(context);
              break;
          }
        },
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final _size = constraints.biggest;
        return SizedBox.square(
          dimension: _size.height / 2,
          child: const AvatarWidget(
            imagePath:
                'assets/images/static_images/avatars/placeholder_avatar/placeholder_avatar_01.png',
          ),
        );
      },
    );
  }
}

class _DropdownItemWrapper extends StatelessWidget {
  const _DropdownItemWrapper({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(
            color: _theme.colorScheme.outline,
          ),
        ),
      ),
      child: child,
    );
  }
}
