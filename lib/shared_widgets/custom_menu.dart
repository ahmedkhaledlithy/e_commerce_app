import 'package:flutter/material.dart';
class MyPopupMenuItem<T> extends PopupMenuItem<T> {
  final Widget child;
  final Function onclick;

  MyPopupMenuItem({@required this.child,@required this.onclick}):super(child:child);

  @override
  PopupMenuItemState<T, PopupMenuItem<T>> createState() {
    return MyPopupMenuItemState();
  }
}

class MyPopupMenuItemState<T,PopMenuItem> extends PopupMenuItemState<T,MyPopupMenuItem<T>>{
  @override
  void handleTap() {
    super.handleTap();
    widget.onclick();
  }
}