import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mayo/utils/constants.dart';
import 'package:mayo/widgets/keyboard_dismissable.dart';

class PhoneNumScreen extends StatelessWidget {
  const PhoneNumScreen({Key? key}) : super(key: key);

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
                  Column(
                    children: [
                      Text(AppLocalizations.of(context)!.logOrRe,
                          style: titleTextStyle),
                      vSpaceS,
                      Text(AppLocalizations.of(context)!.toSendPhone,
                          style: subtitleTextStyle),
                      vSpaceXL,
                      const PhoneNumTextField(),
                    ],
                  ),
                  Container(
                    width: 240,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: const ShapeDecoration(
                      shape: StadiumBorder(),
                      gradient: mainGradient,
                    ),
                    child: MaterialButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: const StadiumBorder(),
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Text(
                        AppLocalizations.of(context)!.sendBySMS,
                        style: subtitleTextStyle,
                      ),
                      onPressed: () {},
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
}

class PhoneNumTextField extends StatefulWidget {
  const PhoneNumTextField({Key? key}) : super(key: key);

  @override
  State<PhoneNumTextField> createState() => _PhoneNumTextFieldState();
}

class _PhoneNumTextFieldState extends State<PhoneNumTextField> {
  final FocusNode _focus = FocusNode();
  Color _bgColor = const Color(0xFFf3f3f3);

  var maskFormatter = MaskTextInputFormatter(
      mask: "### ### ####",
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.eager);

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    setState(() {
      if (_focus.hasFocus) {
        _bgColor = lightYellowColor;
      } else {
        _bgColor = const Color(0xFFf3f3f3);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.transparent),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/thailand.png', width: 24),
                  hSpaceS,
                  Text("+66", style: subtitleTextStyle),
                  hSpaceM,
                ],
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
            hintText: '099 999 9999',
            counterText: '',
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32)),
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32)),
                borderSide: BorderSide(color: Colors.transparent)),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32)),
              borderSide: BorderSide(color: darkYellowColor),
            ),
            filled: true,
            fillColor: _bgColor,
          ),
          textAlignVertical: TextAlignVertical.center,
          keyboardType: const TextInputType.numberWithOptions(),
          maxLength: 12,
          maxLines: 1,
          style: headerTextStyle,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            maskFormatter
          ],
          autofocus: true,
          focusNode: _focus,
        ),
      ),
    );
  }
}
