import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/data/model/response/category_list_reponse.dart';
import 'package:meditation_app/ui/screens/search/util/query_time.dart';

import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../common/common_bottom_sheet_widget.dart';
import 'outlined_selectable_button.dart';

class OptionsSelectionSheet extends StatefulWidget {
  final List<QueryTime> queryItems;
  final List<CategoryListResponse> categoryList;
  final List<String> selectedItems;
  final bool multiSelect;
  final bool useGridLayout;
  final String title;
  final void Function(List<CategoryListResponse>, List<String>)? onCategorySelect;
  final void Function(QueryTime)? onTimeSelect;

  OptionsSelectionSheet.singleSelect({
    super.key,
    required this.queryItems,
    String? selectedItem,
    this.useGridLayout = false,
    required this.title,
    required this.onTimeSelect,
  })  : selectedItems = selectedItem == null ? [] : [selectedItem],
        multiSelect = false,
        categoryList = [],
        onCategorySelect = null;

  OptionsSelectionSheet.multiSelect({super.key, required this.categoryList, required this.selectedItems, this.useGridLayout = false, required this.title, this.onCategorySelect})
      : multiSelect = true,
        queryItems = [],
        onTimeSelect = null;

  @override
  State<OptionsSelectionSheet> createState() => _OptionsSelectionSheetState();
}

class _OptionsSelectionSheetState extends State<OptionsSelectionSheet> {
  final List<CategoryListResponse> _selectedCategory = [];

  @override
  void initState() {
    // if (widget.categoryList.isNotEmpty) _selectedCategory.add(widget.categoryList.first);
    widget.categoryList.map((e) {
      if(widget.selectedItems.contains(e.title)){
        _selectedCategory.add(e);
      }
    }).toList();
    log("init----->${_selectedCategory.length}");
    super.initState();
  }

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
                      _selectedCategory.clear();
                    });
                  }
                : null,
          ),
          Expanded(
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
                        widget.categoryList.length,
                        (index) {
                          bool isSelected = widget.selectedItems.contains(widget.categoryList[index].title);
                          return OutlinedSelectableButton(
                            appStyle: _style,
                            selected: isSelected,
                            title: widget.categoryList[index].title!,
                            constraints: BoxConstraints(minWidth: _style.scaleX(100)),
                            onTap: () {
                              if (isSelected) {
                                widget.selectedItems.remove(widget.categoryList[index].title!);
                                // _selectedCategory.remove(widget.categoryList[index]);
                                _selectedCategory.removeWhere((element) {
                                  return element.title == widget.categoryList[index].title;
                                });
                                log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~${_selectedCategory.length}------${widget.selectedItems}");
                                setState(() {});
                              } else {
                                if (!widget.multiSelect && widget.selectedItems.isNotEmpty) {
                                  widget.selectedItems.clear();
                                  _selectedCategory.clear();
                                }
                                widget.selectedItems.add(widget.categoryList[index].title!);
                                _selectedCategory.add(widget.categoryList[index]);
                                log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~${_selectedCategory.length}-----------${widget.selectedItems}");
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
                    itemCount: widget.queryItems.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: _style.scaleX(110),
                      mainAxisExtent: _style.scaleX(33),
                      crossAxisSpacing: _style.scaleX(15),
                      mainAxisSpacing: _style.scaleX(25),
                    ),
                    itemBuilder: (context, index) {
                      bool isSelected = widget.selectedItems.contains(widget.queryItems[index].showTitle);
                      return OutlinedSelectableButton(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        appStyle: _style,
                        selected: isSelected,
                        title: widget.queryItems[index].showTitle,
                        alignment: Alignment.center,
                        onTap: () {
                          if (isSelected) {
                            widget.selectedItems.remove(widget.queryItems[index].showTitle);
                            setState(() {});
                          } else {
                            if (!widget.multiSelect && widget.selectedItems.isNotEmpty) {
                              widget.selectedItems.clear();
                            }
                            widget.selectedItems.add(widget.queryItems[index].showTitle);
                            widget.onTimeSelect!(widget.queryItems[index]);
                            setState(() {});
                          }

                          context.pop();
                        },
                      );
                    },
                  ),
          ),
          if (!widget.useGridLayout)
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  log("on save press-----------${widget.selectedItems.length}");
                  widget.onCategorySelect!(_selectedCategory, widget.selectedItems);
                  context.pop();
                },
                style: TextButton.styleFrom(
                  textStyle: _style.text.font(mulishMedium500, sizePx: 20),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save'),
              ),
            ),
        ],
      ),
    );
  }
}
