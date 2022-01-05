class RegisterDataModel {
  bool status;
  String message;
  DataModel data;


  RegisterDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new DataModel.fromJson(json['data']) : null;
  }

}

class DataModel {
  String name;
  String email;
  String phone;
  int id;
  String image;
  String token;


  DataModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    id = json['id'];
    image = json['image'];
    token = json['token'];
  }


}
