import 'model.dart';

class BannerMessages extends Model {
  BannerMessages({
    this.title,
    this.content,
    this.imgPic,
    this.url,
  });

  String? title;
  String? content;
  String? imgPic;
  String? url;

  factory BannerMessages.fromJson(Map<String, dynamic> json) => BannerMessages(
    title: json["title"],
    content: json["content"],
    imgPic: json["imgPic"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "content": content,
    "imgPic": imgPic,
    "url": url,
  };
}
