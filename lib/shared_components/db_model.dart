class DBModel {
  DBModel(
      {this.id,
      required this.projectName,
      required this.createDateTime,
      required this.gpxPath,
      required this.videoPath});

  int? id;
  final String projectName;
  final String createDateTime;
  final String gpxPath;
  final String videoPath;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectName': projectName,
      'createDateTime': createDateTime,
      'gpxPath': gpxPath,
      'videoPath': videoPath,
    };
  }

  @override
  String toString() {
    return 'DBModel{id: $id, projectName: $projectName, createDateTime: $createDateTime, gpxPath: $gpxPath, videoPath: $videoPath}';
  }
}
