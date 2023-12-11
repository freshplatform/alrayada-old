import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilePickerWidget extends StatefulWidget {
  const FilePickerWidget({super.key, required this.onPickFile});

  final Function(File file) onPickFile;

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  var _file = File('');
  var _name = '';

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      dialogTitle: 'Pick image',
      lockParentWindow: true,
    );
    if (result == null) return;
    _file = File(result.files.single.path!);
    setState(() {
      _name = result.files.single.name;
    });
    widget.onPickFile(_file);
  }

  void _dragAndDrop(DropDoneDetails details) {
    final file = details.files.first;
    if (!isImageFile(file.path)) {
      return;
    }
    _file = File(file.path);
    setState(() {
      _name = file.name;
    });
    widget.onPickFile(_file);
  }

  bool isImageFile(String filePath) {
    final imageFormats = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'];
    final fileType = filePath.split('.').last.toLowerCase();
    return imageFormats.contains(fileType);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: DropTarget(
            onDragDone: _dragAndDrop,
            child: Center(
              child: ElevatedButton(
                onPressed: _pickFiles,
                child: Text(_name.isEmpty ? 'Select' : _name),
              ),
            ),
          ),
        )
      ],
    );
  }
}
