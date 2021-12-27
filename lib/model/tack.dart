class Tack {
  late String id;
  late String content;
  late DateTime timestamp;

  Tack.fromJson(Map<String, dynamic> json) {
    id = json["id"]!;
    content = json["content"]!;
    timestamp = DateTime.parse(json["date"]!);
  }
}
