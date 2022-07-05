import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                  Expanded(
                    flex: 1,
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        firstStepPage(context),
                        secondStepPage(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget firstStepPage(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.whatDescYou,
            style: headerTextStyle(darkTextColor)),
        vSpaceXL,
        Cta(label: AppLocalizations.of(context)!.s_c),
        vSpaceM,
        Cta(label: AppLocalizations.of(context)!.t_a),
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
          const RegisterForm(),
        ],
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
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
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16),
                labelText: AppLocalizations.of(context)!.name,
                labelStyle: normalTextStyle(lightTextColor),
                counterText: '',
                border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.grey.shade200)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.grey.shade200)),
                focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: darkYellowColor)),
                errorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: normalRedColor)),
                focusedErrorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: normalRedColor)),
              ),
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
              maxLength: 255,
              maxLines: 1,
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
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    labelText: AppLocalizations.of(context)!.age,
                    labelStyle: normalTextStyle(lightTextColor),
                    counterText: '',
                    border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.grey.shade200)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.grey.shade200)),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: darkYellowColor)),
                    errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: normalRedColor)),
                    focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: normalRedColor)),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  maxLines: 1,
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
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    labelText: AppLocalizations.of(context)!.gender,
                    labelStyle: normalTextStyle(lightTextColor),
                    counterText: '',
                    border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.grey.shade200)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.grey.shade200)),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: darkYellowColor)),
                    errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: normalRedColor)),
                    focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: normalRedColor)),
                  ),
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
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
