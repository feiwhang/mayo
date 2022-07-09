import 'package:flutter/material.dart';
import 'package:mayo/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({Key? key, required this.errTitle, required this.errText})
      : super(key: key);
  final String errTitle;
  final String errText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/icons/cancel.png', width: 72),
          vSpaceXL,
          Text(
            errTitle,
            textAlign: TextAlign.center,
            style: headerTextStyle(darkRedColor),
          ),
          vSpaceS,
          Text(
            errText,
            textAlign: TextAlign.center,
            style: normalTextStyle(normalTextColor),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text(
            'OK',
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class SuccessDialog extends StatelessWidget {
  const SuccessDialog(
      {Key? key, required this.successTitle, required this.successText})
      : super(key: key);
  final String successTitle;
  final String successText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/icons/check.png', width: 72),
          vSpaceXL,
          Text(
            successTitle,
            textAlign: TextAlign.center,
            style: headerTextStyle(darkGreenColor),
          ),
          vSpaceS,
          Text(
            successText,
            textAlign: TextAlign.center,
            style: normalTextStyle(normalTextColor),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text(
            'OK',
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key, this.loadingText}) : super(key: key);
  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              color: darkestYellowColor,
              strokeWidth: 2,
            ),
          ),
          vSpaceXL,
          Text(
            loadingText ?? AppLocalizations.of(context)!.loading,
            style: headerTextStyle(darkTextColor),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
