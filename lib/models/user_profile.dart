enum SkinTone {
  porcelain,
  warmBeige,
  honey,
  caramel,
  umber,
  deepEbony,
}

extension SkinToneX on SkinTone {
  String get label {
    switch (this) {
      case SkinTone.porcelain:
        return 'Porcelain';

      case SkinTone.warmBeige:
        return 'Warm Beige';

      case SkinTone.honey:
        return 'Honey';

      case SkinTone.caramel:
        return 'Caramel';

      case SkinTone.umber:
        return 'Umber';

      case SkinTone.deepEbony:
        return 'Deep Ebony';
    }
  }
}

class UserProfile {
  SkinTone? skinTone;
  String? occasion;
  String? outfitType;
  String? style;

  UserProfile({
    this.skinTone,
    this.occasion,
    this.outfitType,
    this.style,
  });

  bool get isComplete =>
      skinTone != null &&
          occasion != null &&
          outfitType != null &&
          style != null;
}