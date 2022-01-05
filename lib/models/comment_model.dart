class CommentModel{
  String uid;
  String textComment;
  String commentTime;
  String image;
  String name;


  CommentModel(
      this.uid,  this.textComment, this.commentTime);

  CommentModel.fromJson(Map<String,dynamic>json)
  {
    uid=json['uid'];
    textComment=json['textComment'];
    commentTime=json['commentTime'];
  }

  Map<String,dynamic> toJson()
  {
    Map<String,dynamic>map={};
    map['uid']=uid;
    map['textComment']=textComment;
    map['commentTime']=commentTime;
    return map;
  }

}