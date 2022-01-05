class PostModel {

  String postImage;
  String postUserImage;
  String postUserName;
  String dateTime;
  String text;
  String uid;
  //List<LikesModel>likes;


  PostModel({this.postImage, this.dateTime, this.text,this.postUserName,this.postUserImage,this.uid});

  PostModel.fromJson(Map<String, dynamic> json)
  {
    postImage= json['postImage'];
    dateTime= json['dateTime'];
    text= json['text'] ;
    postUserName = json['postUserName'] ;
    postUserImage = json['postUserImage'];
    uid=json['uid'];
  }

  Map<String,dynamic> toMap()
  {
    return {
      'postImage':postImage,
      'text':text,
      'dateTime':dateTime,
      'postUserImage':postUserImage,
      'postUserName':postUserName,
      'uid':uid,
    };
  }

}

class LikesModel{

  String userName;
  String userImage;

  LikesModel({this.userName, this.userImage});

  LikesModel.fromJson(Map<String,dynamic> json)
  {
    userImage=json['userImage'];
    userName=json['userName'];
  }

  Map<String,dynamic> toMap()
  {
    return {
      'userName':userName,
      'userImage':userImage
    };
  }
}

