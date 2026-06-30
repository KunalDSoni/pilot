import 'package:freezed_annotation/freezed_annotation.dart';

enum FuelType {
  @JsonValue('petrol')
  petrol,
  @JsonValue('diesel')
  diesel,
  @JsonValue('electric')
  electric,
  @JsonValue('hybrid')
  hybrid,
  @JsonValue('cng')
  cng,
  @JsonValue('lpg')
  lpg,
}
