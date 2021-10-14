// ignore_for_file: prefer_if_elements_to_conditional_expressions
// ignore_for_file: avoid_unnecessary_setstate

import 'package:bausch/packages/alphabet_scroll_view/lib/src/meta.dart';
import 'package:bausch/theme/styles.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum LetterAlignment { left, right }

class AlphabetScrollView extends StatefulWidget {
  AlphabetScrollView({
    Key? key,
    required this.list,
    this.alignment = LetterAlignment.right,
    this.isAlphabetsFiltered = true,
    this.overlayWidget,
    required this.selectedTextStyle,
    required this.unselectedTextStyle,
    this.itemExtent = 40,
    required this.itemBuilder,
  }) : super(key: key);

  // ignore: member-ordering-extended
  /// List of Items should be non Empty
  /// and you must map your
  /// ```
  ///  List<T> to List<AlphaModel>
  ///  e.g
  ///  List<UserModel> _list;
  ///  _list.map((user)=>AlphaModel(user.name)).toList();
  /// ```
  /// where each item of this ```list``` will be mapped to
  /// each widget returned by ItemBuilder to uniquely identify
  /// that widget.
  final List<AlphaModel> list;

  // ignore: member-ordering-extended
  /// ```itemExtent``` specifies the max height of the widget returned by
  /// itemBuilder if not specified defaults to 40.0
  final double itemExtent;

  // ignore: member-ordering-extended
  /// Alignment for the Alphabet List
  /// can be aligned on either left/right side
  /// of the screen
  final LetterAlignment alignment;

  // ignore: member-ordering-extended
  /// defaults to ```true```
  /// if specified as ```false```
  /// all alphabets will be shown regardless of
  /// whether the item in the [list] exists starting with
  /// that alphabet.

  final bool isAlphabetsFiltered;

  // ignore: member-ordering-extended
  /// Widget to show beside the selected alphabet
  /// if not specified it will be hidden.
  /// ```
  /// overlayWidget:(value)=>
  ///    Container(
  ///       height: 50,
  ///       width: 50,
  ///       alignment: Alignment.center,
  ///       color: Theme.of(context).primaryColor,
  ///       child: Text(
  ///                 '$value'.toUpperCase(),
  ///                  style: TextStyle(fontSize: 20, color: Colors.white),
  ///              ),
  ///      )
  /// ```

  final Widget Function(String)? overlayWidget;

  // ignore: member-ordering-extended
  /// Text styling for the selected alphabet by which
  /// we can customize the font color, weight, size etc.
  /// ```
  /// selectedTextStyle:
  ///   TextStyle(
  ///     fontWeight: FontWeight.bold,
  ///     color: Colors.black,
  ///     fontSize: 20
  ///   )
  /// ```

  final TextStyle selectedTextStyle;

  // ignore: member-ordering-extended
  /// Text styling for the unselected alphabet by which
  /// we can customize the font color, weight, size etc.
  /// ```
  /// unselectedTextStyle:
  ///   TextStyle(
  ///     fontWeight: FontWeight.normal,
  ///     color: Colors.grey,
  ///     fontSize: 18
  ///   )
  /// ```

  final TextStyle unselectedTextStyle;

  /// The itemBuilder must return a non-null widget and the third paramter id specifies
  /// the string mapped to this widget from the ```[list]``` passed.

  Widget Function(BuildContext, int, String) itemBuilder;

  @override
  _AlphabetScrollViewState createState() => _AlphabetScrollViewState();
}

class _AlphabetScrollViewState extends State<AlphabetScrollView> {
  void init() {
    widget.list
        .sort((x, y) => x.key.toLowerCase().compareTo(y.key.toLowerCase()));

    _list = widget.list;
    setState(() {});

    /// filter Out AlphabetList
    if (widget.isAlphabetsFiltered) {
      var temp = <String>[];
      alphabets.forEach((letter) {
        var firstAlphabetElement = _list.firstWhereOrNull(
          (item) => item.key.toLowerCase().startsWith(
                letter.toLowerCase(),
              ),
        );
        if (firstAlphabetElement != null) {
          temp.add(letter);
        }
      });
      _filteredAlphabets = temp;
    } else {
      _filteredAlphabets = alphabets;
    }
    calculateFirstIndex();
    setState(() {});
  }

  // ignore: member-ordering-extended
  @override
  void initState() {
    init();
    if (listController.hasClients) {
      maxScroll = listController.position.maxScrollExtent;
    }
    super.initState();
  }

  ScrollController listController = ScrollController();
  final _selectedIndexNotifier = ValueNotifier<int>(0);
  final positionNotifer = ValueNotifier<Offset>(Offset(0, 0));
  final Map<String, int> firstIndexPosition = {};
  List<String> _filteredAlphabets = [];
  final letterKey = GlobalKey();
  List<AlphaModel> _list = [];
  bool isLoading = false;
  bool isFocused = false;
  final key = GlobalKey();

  @override
  void didUpdateWidget(covariant AlphabetScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.list != widget.list ||
        oldWidget.isAlphabetsFiltered != widget.isAlphabetsFiltered) {
      _list.clear();
      firstIndexPosition.clear();
      init();
    }
  }

  int getCurrentIndex(double vPosition) {
    var kAlphabetHeight = letterKey.currentContext!.size!.height;
    return (vPosition ~/ kAlphabetHeight);
  }

  /// calculates and Maintains a map of
  /// [letter:index] of the position of the first Item in list
  /// starting with that letter.
  /// This helps to avoid recomputing the position to scroll to
  /// on each Scroll.
  void calculateFirstIndex() {
    _filteredAlphabets.forEach((letter) {
      var firstElement = _list.firstWhereOrNull(
        (item) => item.key.toLowerCase().startsWith(letter),
      );
      if (firstElement != null) {
        var index = _list.indexOf(firstElement);
        firstIndexPosition[letter] = index;
      }
    });
  }

  //var index = firstIndexPosition[_filteredAlphabets[x].toLowerCase()]!;

  void scrolltoIndex(int x, Offset offset) {
    var index = firstIndexPosition[_filteredAlphabets[x].toLowerCase()]!;
    final scrollToPostion = widget.itemExtent * index;
    if (index != null) {
      listController.animateTo(
        (scrollToPostion),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    positionNotifer.value = offset;
  }

  void onVerticalDrag(Offset offset) {
    var index = getCurrentIndex(offset.dy);

    if (index < 0 || index >= _filteredAlphabets.length) return;
    _selectedIndexNotifier.value = index;
    setState(() {
      isFocused = true;
    });
    scrolltoIndex(index, offset);
  }

  double? maxScroll;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ListView.builder(
        //   controller: listController,
        //   scrollDirection: Axis.vertical,
        //   itemCount: _list.length,
        //   physics: const BouncingScrollPhysics(),
        //   itemBuilder: (_, x) {
        //     return ConstrainedBox(
        //       constraints: BoxConstraints(maxHeight: widget.itemExtent),
        //       child: widget.itemBuilder(_, x, _list[x].key),
        //     );
        //   },
        // ),
        ListView.separated(
          controller: listController,
          scrollDirection: Axis.vertical,
          itemCount: _list.length + 1,
          physics: const BouncingScrollPhysics(),
          separatorBuilder: (_, x) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: widget.itemExtent),
              child: widget.itemBuilder(_, x, _list[x].key),
            );
          },
          itemBuilder: (context, i) {
            for (var element in _filteredAlphabets) {
              if (i == firstIndexPosition[element.toLowerCase()]!) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30, top: i == 0 ? 30 : 0),
                    child: CircleAvatar(
                      child: Text(
                        element.toUpperCase(),
                        style: AppStyles.h2,
                      ),
                      radius: 22,
                      backgroundColor: Colors.white,
                    ),
                  ),
                );
              }
            }
            return Container();
          },
        ),
        Align(
          alignment: widget.alignment == LetterAlignment.left
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Container(
            key: key,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: SingleChildScrollView(
              child: GestureDetector(
                onVerticalDragStart: (z) => onVerticalDrag(z.localPosition),
                onVerticalDragUpdate: (z) => onVerticalDrag(z.localPosition),
                onVerticalDragEnd: (z) {
                  setState(() {
                    isFocused = false;
                  });
                },
                child: ValueListenableBuilder<int>(
                  valueListenable: _selectedIndexNotifier,
                  builder: (context, selected, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _filteredAlphabets.length,
                        (x) => GestureDetector(
                          key: x == selected ? letterKey : null,
                          onTap: () {
                            _selectedIndexNotifier.value = x;
                            scrolltoIndex(x, positionNotifer.value);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 2,
                            ),
                            child: Text(
                              _filteredAlphabets[x].toUpperCase(),
                              style: selected == x
                                  ? widget.selectedTextStyle
                                  : widget.unselectedTextStyle,
                              // style: TextStyle(
                              //     fontSize: 12,
                              //     fontWeight: selected == x
                              //         ? FontWeight.bold
                              //         : FontWeight.normal),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        !isFocused
            ? Container()
            : ValueListenableBuilder<Offset>(
                valueListenable: positionNotifer,
                builder: (context, position, child) {
                  return Positioned(
                    right:
                        widget.alignment == LetterAlignment.right ? 40 : null,
                    left: widget.alignment == LetterAlignment.left ? 40 : null,
                    top: position.dy,
                    child: widget.overlayWidget == null
                        ? Container()
                        : widget.overlayWidget!(
                            _filteredAlphabets[_selectedIndexNotifier.value]),
                  );
                },
              ),
      ],
    );
  }
}

class AlphaModel {
  final String key;
  final String? secondaryKey;

  AlphaModel(this.key, {this.secondaryKey});
}
