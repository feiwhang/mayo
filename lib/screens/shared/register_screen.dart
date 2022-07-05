import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mayo/class/user_role.dart';
import 'package:mayo/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mayo/utils/text_formatter.dart';
import 'package:mayo/widgets/cta.dart';
import 'package:mayo/widgets/keyboard_dismissable.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key, required this.phoneNum}) : super(key: key);
  final String phoneNum;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissable(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          iconTheme: const IconThemeData(color: normalTextColor, size: 18),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          color: Colors.white,
          child: SafeArea(
            child: SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.register,
                            style: titleTextStyle),
                        vSpaceM,
                        Text(
                            "${AppLocalizations.of(context)!.yourNum} ${phoneNumFormatter.maskText(phoneNum)}",
                            style: subtitleTextStyle),
                        vSpaceXL,
                      ],
                    ),
                  ),
                  const Expanded(flex: 1, child: RegisterView()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final PageController _pageController = PageController();
  UserRole? userRole;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: [
        firstStepPage(context),
        secondStepPage(context),
      ],
    );
  }

  Widget firstStepPage(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.whatDescYou,
            style: headerTextStyle(darkTextColor)),
        vSpaceXL,
        Cta(
          label: AppLocalizations.of(context)!.s_c,
          onPressed: () {
            setState(() {
              userRole = UserRole.user;
            });
            _pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          },
        ),
        vSpaceM,
        Cta(
          label: AppLocalizations.of(context)!.t_a,
          onPressed: () {
            setState(() {
              userRole = UserRole.admin;
            });
            _pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          },
        ),
      ],
    );
  }

  Widget secondStepPage(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(AppLocalizations.of(context)!.enterInfo,
              style: headerTextStyle(darkTextColor)),
          vSpaceXL,
          RegisterInformation(userRole: userRole),
        ],
      ),
    );
  }
}

class RegisterInformation extends StatefulWidget {
  const RegisterInformation({Key? key, this.userRole}) : super(key: key);

  final UserRole? userRole;

  @override
  State<RegisterInformation> createState() => _RegisterInformationState();
}

class _RegisterInformationState extends State<RegisterInformation> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _gender;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            width: 256,
            child: TextFormField(
              decoration: roundedRectDecor(AppLocalizations.of(context)!.name),
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
              maxLength: 255,
              maxLines: 1,
              controller: _nameController,
              style: normalTextStyle(darkTextColor),
            ),
          ),
          vSpaceM,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 120,
                child: TextFormField(
                  decoration:
                      roundedRectDecor(AppLocalizations.of(context)!.age),
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 3,
                  maxLines: 1,
                  controller: _ageController,
                  style: normalTextStyle(darkTextColor),
                ),
              ),
              hSpaceM,
              SizedBox(
                width: 120,
                child: DropdownButtonFormField<String>(
                  value: _gender,
                  items: <String>[
                    AppLocalizations.of(context)!.male,
                    AppLocalizations.of(context)!.female,
                    AppLocalizations.of(context)!.others,
                  ]
                      .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ))
                      .toList(),
                  onChanged: (String? newGender) {
                    setState(() {
                      _gender = newGender;
                    });
                  },
                  style: normalTextStyle(normalTextColor),
                  focusColor: brightYellowColor,
                  elevation: 1,
                  dropdownColor: lightestGreyColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  decoration:
                      roundedRectDecor(AppLocalizations.of(context)!.gender),
                ),
              )
            ],
          ),
          vSpaceXL,
          Container(
            width: 228,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const ShapeDecoration(
              shape: StadiumBorder(),
              gradient: mainGradientH,
            ),
            child: MaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const StadiumBorder(),
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Text(
                AppLocalizations.of(context)!.confirm,
                style: subtitleTextStyle,
              ),
              onPressed: () {
                print(widget.userRole.toString());
                print(_nameController.text);
                print(_ageController.text);
                print(_gender);
                // TODO: register user on firebase
              },
            ),
          ),
        ],
      ),
    );
  }
}
