enum SkinTone { porcelain, warmBeige, honey, caramel, umber, deepEbony }

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

class StylingPreferences {
  String? ageRange;
  String? gender;
  SkinTone? skinTone;
  String? occasion;
  String? outfitType;
  String? style;

  StylingPreferences({
    this.ageRange,
    this.gender,
    this.skinTone,
    this.occasion,
    this.outfitType,
    this.style,
  });

  bool get isComplete => occasion != null && outfitType != null;
}

typedef UserProfile = StylingPreferences;
