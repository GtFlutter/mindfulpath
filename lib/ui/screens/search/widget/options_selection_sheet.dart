import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/styles.dart';
import '../../../common/common_bottom_sheet_widget.dart';
import 'outlined_selectable_button.dart';

class OptionsSelectionSheet extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final bool multiSelect;
  final bool useGridLayout;
  final String title;

  OptionsSelectionSheet.singleSelect({
    super.key,
    required this.items,
    String? selectedItem,
    this.useGridLayout = false,
    required this.title,
  })  : selectedItems = selectedItem == null ? [] : [selectedItem],
        multiSelect = false;

  const OptionsSelectionSheet.multiSelect({
    super.key,
    required this.items,
    required this.selectedItems,
    this.useGridLayout = false,
    required this.title,
  }) : multiSelect = true;

  @override
  State<OptionsSelectionSheet> createState() => _OptionsSelectionSheetState();
}

class _OptionsSelectionSheetState extends State<OptionsSelectionSheet> {
  static AppStyle _style = AppStyle();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    return ColoredBox(
      color: const Color(0xFF2D251F),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonBottomSheetWidget(
            style: _style,
            title: widget.title,
            doneLable: 'Clear',
            onCancle: () {
              if (context.canPop()) {
                context.pop();
              }
            },
            onDone: widget.selectedItems.isNotEmpty
                ? () {
                    setState(() {
                      widget.selectedItems.clear();
                    });
                  }
                : null,
          ),
          Flexible(
            child: !widget.useGridLayout
                ? SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: _style.scaleX(20),
                      right: _style.scaleX(20),
                      bottom: _style.scaleX(20),
                    ),
                    child: Wrap(
                      spacing: _style.scaleX(15),
                      runSpacing: _style.scaleX(25),
                      children: List.generate(
                        widget.items.length,
                        (index) {
                          bool isSelected = widget.selectedItems.contains(widget.items[index]);
                          return OutlinedSelectableButton(
                            appStyle: _style,
                            selected: isSelected,
                            title: widget.items[index],
                            constraints: BoxConstraints(minWidth: _style.scaleX(100)),
                            onTap: () {
                              if (isSelected) {
                                widget.selectedItems.remove(widget.items[index]);
                                setState(() {});
                              } else {
                                if (!widget.multiSelect && widget.selectedItems.isNotEmpty) {
                                  widget.selectedItems.clear();
                                }
                                widget.selectedItems.add(widget.items[index]);
                                setState(() {});
                              }
                            },
                          );
                        },
                      ).toList(),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                      left: _style.scaleX(20),
                      right: _style.scaleX(20),
                      bottom: _style.scaleX(20),
                    ),
                    itemCount: widget.items.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: _style.scaleX(110),
                      mainAxisExtent: _style.scaleX(33),
                      crossAxisSpacing: _style.scaleX(15),
                      mainAxisSpacing: _style.scaleX(25),
                    ),
                    itemBuilder: (context, index) {
                      bool isSelected = widget.selectedItems.contains(widget.items[index]);
                      return OutlinedSelectableButton(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        appStyle: _style,
                        selected: isSelected,
                        title: widget.items[index],
                        alignment: Alignment.center,
                        onTap: () {
                          if (isSelected) {
                            widget.selectedItems.remove(widget.items[index]);
                            setState(() {});
                          } else {
                            if (!widget.multiSelect && widget.selectedItems.isNotEmpty) {
                              widget.selectedItems.clear();
                            }
                            widget.selectedItems.add(widget.items[index]);
                            setState(() {});
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
