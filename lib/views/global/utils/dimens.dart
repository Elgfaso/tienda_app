import 'package:flutter/material.dart';

double wSpaceMin = 2.0;
double wSpaceSmall = 4.0;
double wSpaceHalf = 8.0;
double wSpaceNormal = 16.0;
double wSpaceLarge = 24.0;
double wSpaceVeryLarge = 32.0;
double wSpaceTooLarge = 56.0;

double hSpaceMin = 2;
double hSpaceSmall = 4.0;
double hSpaceHalf = 8.0;
double hSpaceNormal = 16.0;
double hSpaceLarge = 24.0;
double hSpaceVeryLarge = 32.0;
double hSpaceTooLarge = 56.0;


class VerticalSpace {
  VerticalSpace._();

  static Widget get min => SizedBox(height: hSpaceMin);

  static Widget get small => SizedBox(height: hSpaceSmall);

  static Widget get half => SizedBox(height: hSpaceHalf);

  static Widget get normal => SizedBox(height: hSpaceNormal);

  static Widget get large => SizedBox(height: hSpaceLarge);

  static Widget get veryLarge => SizedBox(height: hSpaceVeryLarge);

  static Widget get tooLarge => SizedBox(height: hSpaceTooLarge);
}

class HorizontalSpace {
  HorizontalSpace._();

  static Widget get min => SizedBox(width: wSpaceMin);

  static Widget get small => SizedBox(width: wSpaceSmall);

  static Widget get half => SizedBox(width: wSpaceHalf);

  static Widget get normal => SizedBox(width: wSpaceNormal);

  static Widget get large => SizedBox(width: wSpaceLarge);

  static Widget get veryLarge => SizedBox(width: wSpaceVeryLarge);

  static Widget get tooLarge => SizedBox(width: wSpaceTooLarge);
}