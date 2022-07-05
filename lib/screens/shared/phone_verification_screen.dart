import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayo/providers/verification_code_error_text_provider.dart';
import 'package:mayo/screens/shared/register_screen.dart';
import 'package:mayo/utils/constants.dart';
import 'package:mayo/utils/text_formatter.dart';
import 'package:mayo/widgets/cta.dart';
import 'package:mayo/widgets/keyboard_dismissable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PhoneVerificationScreen extends ConsumerWidget {
  const PhoneVerificationScreen({Key? key, required this.phoneNum})
      : super(key: key);
  final String phoneNum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();

    final VerificationCodeErrorTextNotifier codeErrorTextNotifier =
        ref.read(verificationCodeErrorTextProvider.notifier);
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
                      Text(AppLocalizations.of(context)!.phoneVerification,
                          style: titleTextStyle),
                      vSpaceM,
                      Text(AppLocalizations.of(context)!.pleasePutCode,
                          style: subtitleTextStyle),
                      vSpaceS,
                      Text(phoneNumFormatter.maskText(phoneNum),
                          style: headerTextStyle(darkTextColor)),
                      vSpaceXL,
                      VerificationCodeTextField(
                        controller: controller,
                        ref: ref,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      const SendAgainTextCountDown(),
                      vSpaceM,
                      Cta(
                        label: AppLocalizations.of(context)!.cont,
                        onPressed: () {
                          bool isValid =
                              codeErrorTextNotifier.validateVerificationCode(
                            controller.text,
                            AppLocalizations.of(context)!.errorVerificationCode,
                          );
                          // TODO: firebase login if user exist
                          if (isValid) {
                            // TODO: push to MainScreen instead if user already signed up
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RegisterScreen(phoneNum: phoneNum),
                                ),
                                (Route<dynamic> route) => false);
                          }
                        },
                      ),
                    ],
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

class SendAgainTextCountDown extends StatefulWidget {
  const SendAgainTextCountDown({Key? key}) : super(key: key);

  @override
  State<SendAgainTextCountDown> createState() => _SendAgainTextCountDownState();
}

class _SendAgainTextCountDownState extends State<SendAgainTextCountDown> {
  Timer? _timer;
  int _count = 60;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_count == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _count--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _count >= 1
        ? RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                    text: AppLocalizations.of(context)!.sendCodeAgainIn,
                    style: normalTextStyle(normalTextColor)),
                TextSpan(
                    text: " ${_count}s",
                    style: normalTextStyle(darkestYellowColor)),
              ],
            ),
          )
        : TextButton(
            onPressed: () {
              // TODO: firebase send verification code again
            },
            style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
                  (states) => Colors.transparent),
              splashFactory: NoSplash.splashFactory,
            ),
            child: Text(AppLocalizations.of(context)!.sendCodeAgain,
                style: normalTextButtonStyle),
          );
  }
}

class VerificationCodeTextField extends StatefulWidget {
  const VerificationCodeTextField(
      {Key? key, required this.controller, required this.ref})
      : super(key: key);

  final TextEditingController controller;
  final WidgetRef ref;

  @override
  State<VerificationCodeTextField> createState() =>
      _VerificationCodeTextFieldState();
}

class _VerificationCodeTextFieldState extends State<VerificationCodeTextField> {
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
    String? errorText = widget.ref.watch(verificationCodeErrorTextProvider);

    return SizedBox(
      width: 198,
      child: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.transparent),
        child: TextField(
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            hintText: '0 0 0 0 0 0',
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
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(),
          maxLength: 11,
          maxLines: 1,
          style: headerTextStyle(darkTextColor),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            codeFormatter
          ],
          autofocus: true,
          focusNode: _focus,
          controller: widget.controller,
        ),
      ),
    );
  }
}
