import 'package:bausch/sections/order_registration/widgets/margin.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

// class OrderTextInput extends StatefulWidget {
//   final String label;
//   const OrderTextInput({
//     required this.label,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<OrderTextInput> createState() => _OrderTextInputState();
// }

// class _OrderTextInputState extends State<OrderTextInput> {
//   late final FocusNode _focusNode;
//   final TextEditingController _controller = TextEditingController();

//   TextStyle _labelStyle = AppStyles.h2GreyBold;

//   @override
//   void initState() {
//     super.initState();
//     _focusNode = FocusNode()..addListener(_labelStyleHandler);
//   }

//   void _labelStyleHandler() {
//     setState(
//       () {
//         setState(
//           () {
//             _labelStyle = _focusNode.hasFocus
//                 ? AppStyles.p1Grey.copyWith(
//                     height: 0.5,
//                     fontSize:
//                         18.6) //! По какой-то причине размер текста label меньше, чем тот, который задается
//                 : _controller.text.isNotEmpty
//                     ? AppStyles.p1Grey
//                         .copyWith(height: 27 / 18.6, fontSize: 18.6)
//                     : AppStyles.h2GreyBold;
//           },
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Margin(
//       margin: const EdgeInsets.only(bottom: 4),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(bottom: 4),
// decoration: BoxDecoration(
//   color: Colors.white,
//   borderRadius: BorderRadius.circular(5),
// ),
//             child: TextField(
//               controller: _controller,
//               focusNode: _focusNode,
//               style: AppStyles.h2Bold,
//               decoration: InputDecoration(
//                 isDense: true,
//                 labelText: widget.label,
//                 // labelStyle: _labelStyle,
//                 labelStyle: _labelStyle,
//                 border: InputBorder.none,
// contentPadding: const EdgeInsets.only(
//   left: 12,
//   top: 10,
//   bottom: 18,
// ),
//               ),
//             ),
//           ),
//           const Text(
//             'Error',
//             style: AppStyles.p1Grey,
//           )
//         ],
//       ),
//     );
//   }
// }

class OrderTextInput extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType inputType;
  const OrderTextInput({
    required this.labelText,
    required this.controller,
    this.inputType = TextInputType.text,
    Key? key,
  }) : super(key: key);

  @override
  State<OrderTextInput> createState() => _OrderTextInputState();
}

class _OrderTextInputState extends State<OrderTextInput> {
  final _focusNode = FocusNode();
  bool _labelStyleFlag = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_labelStyleHandler);
  }

  void _labelStyleHandler() {
    setState(
      () {
        setState(
          () {
            _labelStyleFlag =
                _focusNode.hasFocus || widget.controller.text.isNotEmpty;
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void setFocus() {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Margin(
      margin: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: setFocus,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  top: 36,
                  bottom: 18,
                ),
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: widget.inputType,
                  style: AppStyles.h2Bold,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
              // width: 200,
              // height: 100,
            ),
            if (_labelStyleFlag)
              Positioned(
                top: 10,
                left: 12,
                child: Container(
                  padding: EdgeInsets.zero,
                  // color: AppTheme.turquoiseBlue,
                  child: Text(
                    widget.labelText,
                    style: AppStyles.p1Grey,
                  ),
                ),
              ),
            if (!_labelStyleFlag)
              Positioned.fill(
                child: Container(
                  padding: const EdgeInsets.only(left: 12),
                  alignment: Alignment.centerLeft,
                  // color: AppTheme.turquoiseBlue,
                  child: Text(
                    widget.labelText,
                    style: AppStyles.h2GreyBold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
