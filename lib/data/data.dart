// Feed Model
class Feed {
  int? id; // 글 번호
  int date; // 작성 날짜
  String title; // 제목
  String comment; // 작성 글
  String image; // 이미지
  int status; // 기분상태

  Feed({
    this.id,
    required this.date,
    required this.title,
    required this.comment,
    required this.image,
    required this.status
  });

  factory Feed.fromDB(Map<String,dynamic> data) {
    return Feed(
        id: data["id"],
        date: data["date"],
        title: data["title"],
        comment: data["comment"],
        image: data["image"],
        status: data["status"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "date": this.date,
      "title": this.title,
      "comment": this.comment,
      "image": this.image,
      "status": this.status
    };
  }

}