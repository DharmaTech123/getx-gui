class ProjectModel {
  String title;
  String location;

  ProjectModel({
    required this.title,
    required this.location,
  });

  ProjectModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        location = json['location'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'location': location,
      };
}
