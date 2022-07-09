import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayo/firebase/auth_services.dart';
import 'package:mayo/providers/phone_num_error_text_provider.dart';
import 'package:mayo/utils/constants/color_const.dart';
import 'package:mayo/utils/constants/space_const.dart';
import 'package:mayo/utils/constants/text_style_const.dart';
import 'package:mayo/utils/text_formatter.dart';
import 'package:mayo/widgets/cta.dart';
import 'package:mayo/widgets/keyboard_dismissable.dart';

class PhoneNumScreen extends ConsumerWidget {
  const PhoneNumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();

    final PhoneNumErrorTextNotifier phoneNumErrorTextNotifier =
        ref.read(phoneNumErrorTextProvider.notifier);

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
                  Column(
                    children: [
                      Text(AppLocalizations.of(context)!.logOrRe,
                          style: titleTextStyle),
                      vSpaceM,
                      Text(AppLocalizations.of(context)!.toSendPhone,
                          style: subtitleTextStyle),
                      vSpaceXL,
                      PhoneNumTextField(controller: controller, ref: ref),
                    ],
                  ),
                  Cta(
                    label: AppLocalizations.of(context)!.sendBySMS,
                    onPressed: () {
                      bool isValid = phoneNumErrorTextNotifier.validatePhoneNum(
                        controller.text,
                        AppLocalizations.of(context)!.errorPhoneNum,
                      );
                      if (isValid) {
                        sendPhoneNumVerificationCode(controller.text);
                      }
                    },
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
  const PhoneNumTextField(
      {Key? key, required this.controller, required this.ref})
      : super(key: key);

  final TextEditingController controller;
  final WidgetRef ref;

  @override
  State<PhoneNumTextField> createState() => _PhoneNumTextFieldState();
}

class _PhoneNumTextFieldState extends State<PhoneNumTextField> {
  final FocusNode _focus = FocusNode();
  Color _bgColor = lightestGreyColor;

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
    widget.controller.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _bgColor = _focus.hasFocus ? lightYellowColor : lightestGreyColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? errorText = widget.ref.watch(phoneNumErrorTextProvider);

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
                  Image.asset('assets/icons/thailand.png', width: 20),
                  hSpaceS,
                  Text("+66", style: subtitleTextStyle),
                  hSpaceM,
                ],
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
            hintText: '099 999 9999',
            hintStyle: headerTextStyle(lightTextColor),
            counterText: '',
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32)),
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32)),
                borderSide: BorderSide(color: Colors.transparent)),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32)),
                borderSide: BorderSide(color: darkYellowColor)),
            errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32)),
                borderSide: BorderSide(color: normalRedColor)),
            focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32)),
                borderSide: BorderSide(color: normalRedColor)),
            filled: true,
            fillColor: errorText == null ? _bgColor : lightRedColor,
            errorText: errorText,
          ),
          textAlignVertical: TextAlignVertical.center,
          keyboardType: const TextInputType.numberWithOptions(),
          maxLength: 12,
          maxLines: 1,
          style: headerTextStyle(darkTextColor),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            phoneNumFormatter
          ],
          autofocus: true,
          focusNode: _focus,
          controller: widget.controller,
        ),
      ),
    );
  }
}
