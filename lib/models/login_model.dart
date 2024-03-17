/*
In the UserData class,
we have both a regular constructor (named fromJson) and a factory constructor (also named fromJson).
The regular constructor is used to set the properties of the UserData object using the values from the JSON data.
 It is not used directly to create an instance in the problematic part of the code.
The factory constructor is used to create a UserData object from the JSON data passed as a parameter.
 It is responsible for returning the new instance of UserData.
By using a factory constructor, we have more control over the object creation process.
 When the LoginModel.fromJson method calls UserData.fromJson,
 the factory constructor can handle null JSON data and return a null instance of UserData if needed,
  which resolves the null safety issue.
In this specific case, the factory constructor does not change the behavior related to null safety directly.
Instead, it allows the LoginModel constructor to handle null data more gracefully when constructing the UserData object.
 By returning null for UserData when the 'data' field in the JSON data is null, we ensure that the 'data' property in LoginModel is also set to null,
 which aligns with the nullable type (UserData?) declared in the LoginModel class. This way,
 the code is null safe, and there is no risk of encountering a "type 'Null' is not a subtype of type 'Map<String, dynamic>'" error.
 */



class LoginModel {
  bool? status;
  String? message;
  UserData? data;

  LoginModel.formJson(Map<String,dynamic> json)
  {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = UserData.fromJson(json['data']);
    } else {
      data = null;
    }

  }
}

class UserData {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  int? points;
  int? credit;
  String? token;
  UserData(
      {this.name,
      this.phone,
      this.email,
      this.credit,
      this.id,
      this.image,
      this.token,
      this.points});

  //named constructor
UserData.formJson(Map<String,dynamic> json)
{
  id = json['id'];
  name = json['name'];
  email = json['email'];
  phone = json['phone'];
  image = json['image'];
  points = json['points'];
  credit = json['credit'];
  token = json['token'];

}
// Factory constructor to create UserData object from JSON data
  /*
  Purpose: The primary purpose of a factory constructor is to provide an alternative way to create objects.
   It can be useful in scenarios where you want to handle object creation based on specific conditions or return a cached instance of an object.

Return Type: Unlike other constructors, a factory constructor does not have an explicit return type. Instead,
 it returns an instance of the class using the return statement.

Object Caching: One common use of factory constructors is object caching.
You can use a factory constructor to create a new instance of an object only if it doesn't already exist.
 If an instance with the same properties already exists,
 the factory constructor can return the existing instance instead of creating a new one.
   */

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      points: json['points'],
      credit: json['credit'],
      token: json['token'],
    );
  }
}
