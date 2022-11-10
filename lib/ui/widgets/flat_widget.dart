import 'package:flutter/material.dart';

Widget FlatButtonX(
    {required Color colorx,
      required Widget childx,
      required RoundedRectangleBorder shapex,
      required Function onPressedx,
      required Color disabledColorx,
      required Color disabledTextColorx,
      required Color textColorx}) {
  if (disabledTextColorx == null && textColorx == null) {
    disabledTextColorx = colorx;
  }
  if (textColorx == null) {
    textColorx = colorx;
  }
  return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          // text color
              (Set<MaterialState> states) => states.contains(MaterialState.disabled)
              ? disabledTextColorx
              : textColorx,
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          // background color    this is color:
              (Set<MaterialState> states) =>
          states.contains(MaterialState.disabled) ? disabledColorx : colorx,
        ),
        shape: MaterialStateProperty.all(shapex),
      ),
      onPressed: onPressedx as void Function(),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0), child: childx));
}

Widget RaisedButtonX(
    {required Color colorx,
      required Widget childx,
      required RoundedRectangleBorder shapex,
      required Function onPressedx,
      required Key keyx,
      required Color disabledColorx,
      required Color disabledTextColorx,
      required Color textColorx}) {
  if (disabledTextColorx == null && textColorx == null) {
    disabledTextColorx = colorx;
  }
  if (textColorx == null) {
    textColorx = colorx;
  }
  return ElevatedButton(
      key: keyx,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          // text color
              (Set<MaterialState> states) => states.contains(MaterialState.disabled)
              ? disabledTextColorx
              : textColorx,
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          // background color    this is color:
              (Set<MaterialState> states) =>
          states.contains(MaterialState.disabled) ? disabledColorx : colorx,
        ),
        shape: MaterialStateProperty.all(shapex),
      ),
      onPressed: onPressedx as void Function(),
      child: childx);
}