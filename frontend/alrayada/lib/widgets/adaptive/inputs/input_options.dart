import 'package:flutter/material.dart';

class CupertinoTextFieldOptions {
  final Widget? prefix;
  final BoxDecoration? decoration;

  CupertinoTextFieldOptions({
    this.prefix,
    this.decoration,
  });
}

class MaterialTextFieldOptions {
  final InputDecoration? inputDecoration;

  MaterialTextFieldOptions({
    this.inputDecoration,
  });
}
