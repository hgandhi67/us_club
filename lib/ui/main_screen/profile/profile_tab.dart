import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/base/globals.dart';
import 'package:us_club/di/export_di.dart';
import 'package:us_club/model/login/login_model.dart';
import 'package:us_club/providers/auth_provider.dart';
import 'package:us_club/providers/providers.dart';
import 'package:us_club/widgets/profile_image.dart';
import 'package:us_club/widgets/text_widget.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab();

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  LoginData userData;

  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).setUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    userData = Provider.of<AuthProvider>(context).currentUser;
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8.0),
            _profileImageLayout(),
            const SizedBox(height: 8.0),
            _sectionCard(
              children: [
                userData != null
                    ? _singleItem(
                        itemIcon: Icons.edit_outlined,
                        title: Strings.editProfile,
                        onItemTap: editProfileClick,
                      )
                    : const SizedBox(),
                _singleItem(
                  itemIcon: Icons.add_box_outlined,
                  title: Strings.orders,
                  onItemTap: () {
                    context.read<IndexProvider>().setIndex(2);
                  },
                ),
                _singleItem(
                  itemIcon: Icons.help_outline_outlined,
                  title: Strings.helpCenter,
                  onItemTap: () => launchUrl(Constants.HELP_CENTER_LINK),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            _sectionCard(
              children: [
                _singleItem(
                  itemIcon: Icons.add_comment_outlined,
                  title: Strings.aboutUs,
                  onItemTap: () => launchUrl(Constants.ABOUT_US_LINK),
                ),
                _singleItem(
                  itemIcon: Icons.assignment_outlined,
                  title: Strings.terms,
                  onItemTap: () => launchUrl(Constants.TERMS_LINK),
                ),
                _singleItem(
                  itemIcon: Icons.person_outline,
                  title: Strings.seller,
                  onItemTap: () => launchUrl(Constants.SELLER_LINK),
                ),
                userData != null
                    ? _singleItem(
                        itemIcon: Icons.login_outlined,
                        title: Strings.logout,
                        onItemTap: () => onLogoutClick(),
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Widget function which provides the UI layout for the profile of the user.
  /// This layout contains the [Stack] of the user background image and [_userLayout] which shows the state of
  /// user logged in or not.
  Widget _profileImageLayout() {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Image.asset(
          ImagesLink.profile_bg,
          fit: BoxFit.cover,
          height: screenHeight * 0.22,
          width: screenWidth,
        ),
        _userLayout()
      ],
    );
  }

  /// Widget function which contains the [Image] of the user and [_userLayout] which shows the state of user
  /// logged in or not.
  Widget _userLayout() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileImage(
            onTap: () => userData == null
                ? navigator.navigateTo(Routes.loginScreen,
                    arguments: LoginScreenArguments(moveBackRoute: Routes.mainScreen))
                : null,
            height: screenWidth * 0.2,
            width: screenWidth * 0.2,
            imageUrl: userData != null
                ? userData.userImage.startsWith('http')
                    ? userData.userImage
                    : userData.userImageLink != null
                        ? userData.userImageLink
                        : ''
                : '',
            useCachedImage: false,
          ),
          const SizedBox(height: 10.0),
          userData == null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => navigator.navigateTo(Routes.loginScreen,
                          arguments: LoginScreenArguments(moveBackRoute: Routes.mainScreen)),
                      child: Texts(Strings.login, color: Palette.white, fontSize: 16.0, fontFamily: bold),
                    ),
                    const SizedBox(width: 15.0),
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => navigator.navigateTo(Routes.otpScreen,
                          arguments: OtpScreenArguments(moveBackRoute: Routes.mainScreen)),
                      child: Texts(Strings.signUp, color: Palette.white, fontSize: 16.0, fontFamily: bold),
                    ),
                  ],
                )
              : Texts(userData != null ? userData.userName : '',
                  color: Palette.white, fontSize: 16.0, fontFamily: bold),
        ],
      ),
    );
  }

  /// Widget function which gives the common ui for the background card of the section.
  Widget _sectionCard({List<Widget> children}) {
    return Card(
      color: Palette.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
      child: Column(children: children),
    );
  }

  /// Widget function for the single item of the card section.
  Widget _singleItem({IconData itemIcon, String title, Function onItemTap}) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => onItemTap?.call(),
      child: SizedBox(
        height: kToolbarHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Row(
            children: [
              Icon(itemIcon, color: Palette.grey, size: 21.0),
              const SizedBox(width: 15.0),
              Texts(title, color: Palette.grey, fontSize: 18.0, fontFamily: semiBold)
            ],
          ),
        ),
      ),
    );
  }

  /// Group of functions which gives different click event functionalists.
  void editProfileClick() {
    navigator.navigateTo(Routes.updateProfilePage);
  }

  void ordersClick() {
    // Change tab
  }

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void onLogoutClick() {
    Provider.of<AuthProvider>(context, listen: false).setCurrentUser(null);
    sharedPref.setString(Constants.AUTH_TOKEN, null);
  }
}
