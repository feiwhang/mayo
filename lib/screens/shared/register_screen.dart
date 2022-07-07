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
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          iconTheme: const IconThemeData(color: normalTextColor, size: 18),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                      ],
                    ),
                  ),
                  vSpaceXL,
                  RegisterView(phoneNum: phoneNum),
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
  const RegisterView({Key? key, required this.phoneNum}) : super(key: key);

  final String phoneNum;

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final PageController pageController = PageController();
  UserRole? userRole;
  int _pageIndex = 1;
  bool isAgreed = false;

  @override
  void initState() {
    pageController.addListener(() {
      setState(() {
        _pageIndex = pageController.page!.toInt() + 1;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    pageController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: _pageIndex == 3 ? 4 : 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                    text: AppLocalizations.of(context)!.step,
                    style: headerTextStyle(darkTextColor)),
                TextSpan(
                    text: " $_pageIndex",
                    style: headerTextStyle(darkestYellowColor)),
                TextSpan(text: " / 3", style: headerTextStyle(normalTextColor)),
              ],
            ),
          ),
          vSpaceS,
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                firstStepPage(context),
                secondStepPage(context),
                thirdStepPage(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget firstStepPage(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.whatDescYou,
            style: subtitleTextStyle),
        vSpaceXL,
        Cta(
          label: AppLocalizations.of(context)!.s_c,
          onPressed: () {
            setState(() {
              userRole = UserRole.user;
            });
            pageController.nextPage(
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
            pageController.animateToPage(
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
              style: subtitleTextStyle),
          vSpaceXL,
          RegisterInformation(
            phoneNum: widget.phoneNum,
            userRole: userRole,
            pageController: pageController,
          ),
        ],
      ),
    );
  }

  Widget thirdStepPage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(AppLocalizations.of(context)!.agreeToTerms,
            style: subtitleTextStyle),
        vSpaceXL,
        const RegisterTerms(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: isAgreed,
              onChanged: (value) {
                setState(() {
                  isAgreed = value ?? false;
                });
              },
              checkColor: Colors.white,
              activeColor: darkestYellowColor,
            ),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                splashFactory: NoSplash.splashFactory,
              ),
              onPressed: () {
                setState(() {
                  isAgreed = !isAgreed;
                });
              },
              child: Text(
                AppLocalizations.of(context)!.byChecking,
                style: normalTextStyle(normalTextColor),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
        Cta(
          label: AppLocalizations.of(context)!.confirm,
          bgColor: isAgreed ? null : lightTextColor,
          onPressed: () {
            if (isAgreed) {
              // TODO: write user info to firestore
            }
          },
        ),
      ],
    );
  }
}

class RegisterInformation extends StatefulWidget {
  const RegisterInformation(
      {Key? key,
      this.userRole,
      required this.phoneNum,
      required this.pageController})
      : super(key: key);

  final String phoneNum;
  final UserRole? userRole;
  final PageController pageController;

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
          Cta(
            label: AppLocalizations.of(context)!.cont,
            onPressed: () {
              // TODO: validate register form
              widget.pageController.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
    );
  }
}

class RegisterTerms extends StatefulWidget {
  const RegisterTerms({Key? key}) : super(key: key);

  @override
  State<RegisterTerms> createState() => _RegisterTermsState();
}

class _RegisterTermsState extends State<RegisterTerms> {
  String? termsText;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final loadedData = await rootBundle.loadString('assets/texts/terms.txt');
    setState(() {
      termsText = loadedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: lightestGreyColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(child: Text(termsText ?? '')),
      ),
    );
  }
}
