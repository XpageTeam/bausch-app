import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class PhoneEditingController extends TextEditingController {
  final inputFormatters = [
    TextInputMask(
      mask: r'\+9 (999) 999-99-99',
    ),
  ];

  int get _phoneLength => text.length;

  String get _lastChar => text.characters.last;

  PhoneEditingController() {
    addListener(_listener);
  }

  void setText(String phone) {
    text = inputFormatters.first.magicMask.getMaskedString(phone);
  }

  String _oldText = '';

  // max length == 18
  void _listener() {
    if (_oldText == text) return;

    if (_phoneLength >= 2) {
      final firstElement = text.characters.elementAt(1);

      if (firstElement != '7') {
        var substring = '';
        if (_phoneLength > 2) {
          substring = text.characters.getRange(4).toString();
        } else {
          substring = firstElement == '8' ? '' : firstElement;
        }

        text = '+7 ($substring';
      }

      if (_phoneLength == 5 && text.characters.last == '8') {
        text = '+7 (';
      }
    }

    SchedulerBinding.instance?.addPostFrameCallback((_) {
      _toEndPosition();
    });

    _oldText = text;
  }

  void _toEndPosition() {
    debugPrint('$_phoneLength');
    selection = TextSelection.fromPosition(
      TextPosition(offset: _phoneLength),
    );
  }
}

//  final lastChar = phoneController.text.characters.last;

//     if (phoneLength == 2 && lastChar != '7') {
//       phoneController.text = '+7 ($lastChar';
//     }

//     if (phoneLength == 5 && lastChar == '8') {
//       phoneController.text = '+7';
//     }

