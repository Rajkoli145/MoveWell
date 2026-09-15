
class SetupProfileData {
  String gender;
  String ageRange;
  int age;
  double weight;
  String weightUnit;
  int height;
  String heightUnit;
  String goal;
  String activityLevel;
  String fullName;
  String dateOfBirth;

  SetupProfileData({
    this.gender = 'Female',
    this.ageRange = '25 - 34',
    this.age = 25,
    this.weight = 60.0,
    this.weightUnit = 'kg',
    this.height = 172,
    this.heightUnit = 'cm',
    this.goal = 'Build Muscle',
    this.activityLevel = 'Moderately Active',
    this.fullName = 'Fred Nicklson',
    this.dateOfBirth = '12 May 2000',
  });
}
