import 'package:freezed_annotation/freezed_annotation.dart';

enum TransmissionType {
  @JsonValue('manual')
  manual,
  @JsonValue('automatic')
  automatic,
  @JsonValue('cvt')
  cvt,
  @JsonValue('dct')
  dct,
}
