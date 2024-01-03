import 'package:flutter/material.dart';

class CupertinoTextFieldOptions {

  CupertinoTextFieldOptions({
    this.prefix,
    this.decoration,
  });
  final Widget? prefix;
  final BoxDecoration? decoration;
}

class MaterialTextFieldOptions {

  MaterialTextFieldOptions({
    this.inputDecoration,
  });
  final InputDecoration? inputDecoration;
}
