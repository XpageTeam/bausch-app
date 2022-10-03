import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class PhoneEditingController extends TextEditingController {
  final inputFormatters = [
    TextInputMask(
      mask: r'\+9 (999) 999-99-99',
    ),
  ];
  String _oldText = '';
  int get _phoneLength => text.length;

  PhoneEditingController() {
    addListener(_listener);
  }

  void setText(String phone) {
    text = inputFormatters.first.magicMask.getMaskedString(phone);
  }

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

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _toEndPosition();
    });

    _oldText = text;
  }

  void _toEndPosition() {
    // debugPrint('$_phoneLength');
    selection = TextSelection.fromPosition(
      TextPosition(offset: _phoneLength),
    );
  }
}
