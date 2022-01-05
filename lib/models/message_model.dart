class MessageModel {

  String dateTime;
  String receiverUid;
  String senderUid;
  String text;
  String image;


  MessageModel(this.dateTime,this.text,this.receiverUid,this.senderUid,this.image);

  MessageModel.fromJson(Map<String, dynamic> json)
  {
    dateTime= json['dateTime'];
    text= json['text'];
    receiverUid= json['receiverUid'];
    senderUid= json['senderUid'];
    image=json['image'];
  }

  Map<String,dynamic> toMap()
  {
    return {
      'senderUid':senderUid,
      'receiverUid':receiverUid,
      'text': text,
      'dateTime': dateTime,
      'image':image,
    };
  }

}

