import 'package:freezed_annotation/freezed_annotation.dart';

part 'rating.freezed.dart';
part 'rating.g.dart';

@freezed
class Rating with _$Rating {
  const factory Rating({
    required int id,
    required int stars,
    String? comment,
    @JsonKey(name: 'reviewer_name') String? reviewerName,
    @JsonKey(name: 'reviewer_avatar') String? reviewerAvatar,
    @JsonKey(name: 'food_name') String? foodName,
    @JsonKey(name: 'food_id') int? foodId,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _Rating;

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);
}
