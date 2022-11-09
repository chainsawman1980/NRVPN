import 'model.dart';

class BannerMessages extends Model {
  BannerMessages({
    this.title,
    this.content,
    this.imgPic,
    this.url,
    this.created_at,
  });

  String? title;
  String? content;
  String? imgPic;
  String? url;
  String? created_at;

  factory BannerMessages.fromJson(Map<String, dynamic> json) => BannerMessages(
    title: json["title"],
    content: json["content"],
    imgPic: json["imgPic"],
    url: json["url"],
    created_at: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "content": content,
    "imgPic": imgPic,
    "url": url,
    "created_at": created_at,
  };
}
