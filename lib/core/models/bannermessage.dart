import 'model.dart';

class BannerMessages extends Model {
  BannerMessages({
    this.title,
    this.content,
    this.imgPic,
    this.jumpurl,
  });

  String? title;
  String? content;
  String? imgPic;
  String? jumpurl;

  factory BannerMessages.fromJson(Map<String, dynamic> json) => BannerMessages(
    title: json["title"],
    content: json["content"],
    imgPic: json["imgPic"],
    jumpurl: json["jumpurl"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "content": content,
    "imgPic": imgPic,
    "jumpurl": jumpurl,
  };
}
