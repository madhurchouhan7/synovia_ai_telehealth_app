class UserHealthModel {
  String? name;
  String? goal;
  String? gender;
  int? age;
  double? height;
  double? weight;
  String? bloodType;
  String? fitnessLevel;
  bool? medicalConditions;
  bool? medication;
  String? specifyMedication;
  String? alcoholConsumption;
  String? allergies;
  String? smokingStatus;
  double? sleepHours;

  // Constructor
  UserHealthModel({
    this.medication,
    this.height,
    this.goal,
    this.sleepHours,
    this.name,
    this.age,
    this.gender,
    this.weight,
    this.bloodType,
    this.fitnessLevel,
    this.medicalConditions,
    this.specifyMedication,
    this.alcoholConsumption,
    this.allergies,
    this.smokingStatus,
  });

  factory UserHealthModel.fromJson(Map<String, dynamic> json) {
    return UserHealthModel(
      sleepHours: json['sleepHours'] as double?,
      name: json['name'] as String?,
      medication: json['medication'] as bool?,
      goal: json['goal'] as String?,
      gender: json['gender'] as String?,
      age: json['age'] as int?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      bloodType: json['bloodType'] as String?,
      fitnessLevel: json['fitnessLevel'] as String?,
      medicalConditions: json['medicalConditions'] as bool?,
      specifyMedication: json['specifyMedication'] as String?,
      alcoholConsumption: json['alcoholConsumption'] as String?,
      allergies: json['allergies'] as String?,
      smokingStatus: json['smokingStatus'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'goal': goal,
      'gender': gender,
      'age': age,
      'weight': weight,
      'bloodType': bloodType,
      'fitnessLevel': fitnessLevel,
      'medicalConditions': medicalConditions,
      'specifyMedication': specifyMedication,
      'alcoholConsumption': alcoholConsumption,
      'allergies': allergies,
      'smokingStatus': smokingStatus,
    };
  }
}
