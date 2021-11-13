import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

/// Дефолтный TextInput для данного проекта
class DefaultTextFormField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType inputType;
  final InputDecoration? decoration;
  final TextStyle? textStyle;
  final FormFieldValidator? validator;
  final String? initialValue;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  const DefaultTextFormField({
    required this.labelText,
    required this.controller,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.initialValue,
    this.validator,
    this.inputType = TextInputType.text,
    this.decoration,
    this.textStyle,
    Key? key,
  }) : super(key: key);

  @override
  State<DefaultTextFormField> createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField>
    with SingleTickerProviderStateMixin {
  //* Используется для того, чтобы прослушивать фокус и менять стиль и положение [label]
  final _focusNode = FocusNode();

  //* Продолжительность анимации изменения стиля и положения [label]
  int labelAnimationDuration = 150;

  //* Флаг, по которому меняются стиль и положение
  bool _isTextInputFocusedOrFilled = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_labelStyleHandler);

    final keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    keyboardVisibilityController.onChange.listen(
      (visible) {
        //* Когда клавиатура скрыта, то убирается фокус с textInput
        if (!visible && mounted) unFocus();
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //* Область textField маленькая, поэтому пришлось обернуть в GestureDetector
      //* и устанавливать фокус при нажатии
      onTap: setFocus,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.only(
              left: 12,
              top: 36,
              bottom: 18,
            ),

            //* Само текстовое поле (декорации вынес в AppTheme)
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: widget.inputType,
              style: widget.textStyle ?? AppStyles.h2Bold,
              decoration: widget.decoration ?? const InputDecoration(),
              validator: widget.validator,
              initialValue: widget.initialValue,
              onFieldSubmitted: widget.onFieldSubmitted,
              inputFormatters: widget.inputFormatters,
            ),
          ),

          //* Здесь выводится [label]
          Positioned.fill(
            //* Здесь анимируется положение [label]
            //* засчет изменения padding и alignment
            child: AnimatedContainer(
              padding: EdgeInsets.only(
                left: 12,
                top: _isTextInputFocusedOrFilled ? 10 : 0,
              ),
              alignment: _isTextInputFocusedOrFilled
                  ? Alignment.topLeft
                  : Alignment.centerLeft,

              //* Здесь анимируется стиль текста
              child: AnimatedDefaultTextStyle(
                child: Text(
                  widget.labelText,
                ),
                style: _isTextInputFocusedOrFilled
                    ? AppStyles.p1Grey
                    : AppStyles.h2GreyBold,
                duration: Duration(milliseconds: labelAnimationDuration),
              ),
              duration: Duration(milliseconds: labelAnimationDuration),
            ),
          ),
        ],
      ),
    );
  }

  void setFocus() {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void unFocus() {
    FocusScope.of(context).unfocus();
  }

  void _labelStyleHandler() {
    setState(
      () {
        //* Если textField с фокусом или textField не пустой, тогда будет
        //* показываться один стиль (маленькая серая [label] слева сверху),
        //* иначе - другой (большая серая [label] в центре).
        _isTextInputFocusedOrFilled =
            _focusNode.hasFocus || widget.controller.text.isNotEmpty;
      },
    );
  }
}
