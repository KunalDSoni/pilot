import 'package:freezed_annotation/freezed_annotation.dart';

part 'inquiry.freezed.dart';
part 'inquiry.g.dart';

@freezed
class Inquiry with _$Inquiry {
  const factory Inquiry({
    required int id,
    required int userId,
    required int variantId,
    int? dealerId,
    required String status,
    String? message,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Inquiry;

  factory Inquiry.fromJson(Map<String, dynamic> json) =>
      _$InquiryFromJson(json);
}
