import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mayo/providers/phone_num_error_text_provider.dart';
import 'package:mayo/screens/phone_verification_screen.dart';
import 'package:mayo/utils/constants.dart';
import 'package:mayo/widgets/keyboard_dismissable.dart';

class PhoneNumScreen extends ConsumerWidget {
  const PhoneNumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();

    final PhoneNumErrorTextNotifier phoneNumNotifier =
        ref.read(phoneNumErrorTextProvider.notifier);

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
                      PhoneNumTextField(controller: controller, ref: ref),
                    ],
                  ),
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
                        AppLocalizations.of(context)!.sendBySMS,
                        style: subtitleTextStyle,
                      ),
                      onPressed: () {
                        bool isValid = phoneNumNotifier.validatePhoneNum(
                          controller.text.replaceAll(' ', ''),
                          AppLocalizations.of(context)!.errorPhoneNum,
                        );

                        if (isValid) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PhoneVerificationScreen(),
                            ),
                          );
                        }
                      },
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

  var maskFormatter = MaskTextInputFormatter(
      mask: "### ### ####",
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

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
                  Image.asset('assets/icons/thailand.png', width: 24),
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
            fillColor: _bgColor,
            errorText: errorText,
          ),
          textAlignVertical: TextAlignVertical.center,
          keyboardType: const TextInputType.numberWithOptions(),
          maxLength: 12,
          maxLines: 1,
          style: headerTextStyle(darkTextColor),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            maskFormatter
          ],
          autofocus: true,
          focusNode: _focus,
          controller: widget.controller,
        ),
      ),
    );
  }
}


// class PhoneNumTextField extends ConsumerWidget {
//   PhoneNumTextField({Key? key}) : super(key: key);

//   final maskFormatter = MaskTextInputFormatter(
//     mask: "### ### ####",
//     filter: {"#": RegExp(r'[0-9]')},
//   );

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final PhoneNum phoneNumValue = ref.watch(phoneNumProvider);
//     final PhoneNumNotifier phoneNumNotifier =
//         ref.read(phoneNumProvider.notifier);

//     return SizedBox(
//       width: 272,
//       child: Theme(
//         data: Theme.of(context).copyWith(splashColor: Colors.transparent),
//         child: Focus(
//           focusNode: phoneNumValue.focusNode,
//           onFocusChange: (bool hasFocus) =>
//               phoneNumNotifier.onFocusChange(hasFocus),
//           child: TextField(
//             decoration: InputDecoration(
//               prefixIcon: Padding(
//                 padding: const EdgeInsets.only(left: 24),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Image.asset('assets/icons/thailand.png', width: 20),
//                     hSpaceS,
//                     Text("+66", style: subtitleTextStyle),
//                     hSpaceM,
//                   ],
//                 ),
//               ),
//               contentPadding: const EdgeInsets.all(16),
//               hintText: '099 999 9999',
//               hintStyle: headerTextStyle(lightTextColor),
//               counterText: '',
//               border: const OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(32)),
//                   borderSide: BorderSide(color: Colors.transparent)),
//               enabledBorder: const OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(32)),
//                   borderSide: BorderSide(color: Colors.transparent)),
//               focusedBorder: const OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(32)),
//                   borderSide: BorderSide(color: darkYellowColor)),

//               filled: true,
//               fillColor: phoneNumValue.inputBgColor,
//               errorText: phoneNumValue.errorText,
//             ),
//             textAlignVertical: TextAlignVertical.center,
//             keyboardType: const TextInputType.numberWithOptions(),
//             maxLength: 12,
//             maxLines: 1,
//             style: headerTextStyle(darkTextColor),
//             inputFormatters: [maskFormatter],
//             autofocus: true,
//             controller: phoneNumValue.controller,
//           ),
//         ),
//       ),
//     );
//   }
// }
