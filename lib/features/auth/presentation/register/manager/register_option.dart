enum Gender { male, female }

enum Goal { gainWeight, loseWeight, getFitter, gainFlexibility, learnBasics }

enum ActivityLevel { rookie, beginner, intermediate, advance, trueBeast }

extension GenderApi on Gender {
  String get apiValue => name;
}

extension GoalApi on Goal {
  String get apiValue => switch (this) {
    Goal.gainWeight => 'Gain weight',
    Goal.loseWeight => 'Lose weight',
    Goal.getFitter => 'Get fitter',
    Goal.gainFlexibility => 'Gain more flexible',
    Goal.learnBasics => 'Learn the basics',
  };
}

extension ActivityLevelApi on ActivityLevel {
  String get apiValue => switch (this) {
    ActivityLevel.rookie => 'level1',
    ActivityLevel.beginner => 'level2',
    ActivityLevel.intermediate => 'level3',
    ActivityLevel.advance => 'level4',
    ActivityLevel.trueBeast => 'level5',
  };
}