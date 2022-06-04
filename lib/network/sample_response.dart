class SampleResponse {
  final int id;
  final String name;
  final String link;
  final List<int> categoryIDList;
  final int lastEditDate;

  SampleResponse(
      {required this.id,
      required this.name,
      required this.link,
      required this.categoryIDList,
      required this.lastEditDate});

  factory SampleResponse.fromJson(Map<String, dynamic> json) {
    List<int> categoryList = [];
    json['categories']?.forEach((category) {
      categoryList.add(category);
    });
    return SampleResponse(
        id: json['id'],
        name: json['name'],
        link: json['link'],
        categoryIDList: categoryList,
        lastEditDate: json['dateLastEdit']);
  }
}
