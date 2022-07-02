import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

var phoneNumFormatter = MaskTextInputFormatter(
  mask: "### ### ####",
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);

var codeFormatter = MaskTextInputFormatter(
  mask: "# # # # # #",
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);
