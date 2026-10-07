import 'package:aura_dart/user.dart';

extension UserSettingsExt on UserSettings {
  bool isDirty({
    List<String>? resetAlgoTags,
    bool? allowInvites,
    double? algoLikeWeight,
    double? algoDislikeWeight,
    double? algoCommentWeight,
    double? algoTimeDecay,
    bool? notifyInvite,
    bool? notifyMessage,
    bool? notifyComment,
  }) =>
      this.resetAlgoTags != (resetAlgoTags ?? this.resetAlgoTags) ||
      this.allowInvites != (allowInvites ?? this.allowInvites) ||
      this.algoLikeWeight != (algoLikeWeight ?? this.algoLikeWeight) ||
      this.algoDislikeWeight != (algoDislikeWeight ?? this.algoDislikeWeight) ||
      this.algoCommentWeight != (algoCommentWeight ?? this.algoCommentWeight) ||
      this.algoTimeDecay != (algoTimeDecay ?? this.algoTimeDecay) ||
      this.notifyInvite != (notifyInvite ?? this.notifyInvite) ||
      this.notifyMessage != (notifyMessage ?? this.notifyMessage) ||
      this.notifyComment != (notifyComment ?? this.notifyComment);

  UserSettings update({
    List<String>? resetAlgoTags,
    bool? allowInvites,
    double? algoLikeWeight,
    double? algoDislikeWeight,
    double? algoCommentWeight,
    double? algoTimeDecay,
    bool? notifyInvite,
    bool? notifyMessage,
    bool? notifyComment,
  }) => UserSettings(
    resetAlgoTags: resetAlgoTags ?? this.resetAlgoTags,
    allowInvites: allowInvites ?? this.allowInvites,
    algoLikeWeight: algoLikeWeight ?? this.algoLikeWeight,
    algoDislikeWeight: algoDislikeWeight ?? this.algoDislikeWeight,
    algoCommentWeight: algoCommentWeight ?? this.algoCommentWeight,
    algoTimeDecay: algoTimeDecay ?? this.algoTimeDecay,
    notifyInvite: notifyInvite ?? this.notifyInvite,
    notifyMessage: notifyMessage ?? this.notifyMessage,
    notifyComment: notifyComment ?? this.notifyComment,
  );
}
