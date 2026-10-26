

class RegisterRequestEntity {
  
    String? firstName;
    String? lastName;
    String? email;
    String? password;
    String? rePassword;
    String? gender;
    int? height;
    int? weight;
    int? age;
    String? goal;
    String? activityLevel;

    RegisterRequestEntity({
        this.firstName,
        this.lastName,
        this.email,
        this.password,
        this.rePassword,
        this.gender,
        this.height,
        this.weight,
        this.age,
        this.goal,
        this.activityLevel,
    });

}
