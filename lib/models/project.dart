class Project {
  String projectId;
  String name;
  String location;
  double latitude;
  double longitude;
  String exec;
  double cost;
  double actualCost;
  DateTime startDate;
  double timespan;
  String goal;
  double completion;
  double rating;

  Project({
    required this.projectId,
    required this.name,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.exec,
    required this.cost,
    required this.actualCost,
    required this.startDate,
    required this.timespan,
    required this.goal,
    required this.completion,
    this.rating = 0,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['projectId'],
      name: json['name'],
      location: json['location'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      exec: json['exec'],
      cost: double.parse(json['cost']),
      actualCost: double.parse(json['actualCost']),
      startDate: DateTime.parse(json['startDate']),
      timespan: double.parse(json['timespan']),
      goal: json['goal'],
      completion: double.parse(json['completion']),
      rating: double.parse(json['rating']??'0'),
    );
  }
}
