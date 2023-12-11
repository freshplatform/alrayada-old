import 'package:flutter/material.dart';

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget(
      {super.key, required this.onPickupDate, required this.label});

  final ValueChanged<DateTime> onPickupDate;
  final String label;

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? _dateTime;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(widget.label),
      onPressed: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().copyWith(year: DateTime.now().year + 2),
        );
        if (date != null) {
          setState(() {
            _dateTime = date;
          });
          widget.onPickupDate(date);
        }
      },
    );
    // return DatePicker(
    //   header: widget.label,
    //   showDay: true,
    //   showMonth: true,
    //   contentPadding: const EdgeInsets.all(4),
    //   selected: _dateTime,
    //   onChanged: (value) => setState(() {
    //     _dateTime = value;
    //     if (_dateTime != null) {
    //       widget.onPickupDate(_dateTime!);
    //     }
    //   }),
    // );
  }
}
