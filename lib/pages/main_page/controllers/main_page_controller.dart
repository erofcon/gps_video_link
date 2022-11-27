import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gps_video_link/shared_components/db_model.dart';
import 'package:gps_video_link/utils/constants.dart';

import '../../../services/storage_service.dart';

class MainPageController extends GetxController {
  late Database database;

  bool pageLoading = true;

  List<Map<String, dynamic>> saveData = [];

  final TextEditingController projectNameTextEditingController =
      TextEditingController();

  @override
  void onInit() {
    _controllerInit();
    super.onInit();
  }

  @override
  void onClose() {
    database.close();
    projectNameTextEditingController.dispose();
    super.onClose();
  }

  void _controllerInit() async {
    database = await openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE ${Constants.databaseTableName}(id INTEGER PRIMARY KEY AUTOINCREMENT, projectName TEXT, createDateTime TEXT, gpxPath TEXT, videoPath TEXT)");
      },
      version: 1,
    );

    saveData = await returnDBData();
    print(saveData);
    pageLoading = false;
    update();
  }

  Future<List<Map<String, Object?>>> returnDBData() async {
    return await database.query(Constants.databaseTableName);
  }

  Future<void> getDBData()async{
    saveData = await database.query(Constants.databaseTableName);
    update();
  }

  void insertDB() async {
    DBModel model = DBModel(
        projectName: "123",
        createDateTime: DateTime.now().toIso8601String(),
        gpxPath: "ssdds",
        videoPath: "sdsdsdsd");

    if (await database.insert(Constants.databaseTableName, model.toMap()) !=
        0) {
      saveData = await returnDBData();
      update();
    }
  }

  Future<void> shareFile(int projectID) async {
    List<Map<String, Object?>> result = await database.query(
        Constants.databaseTableName,
        where: "id=?",
        whereArgs: [projectID]);
  
    Share.shareXFiles([
      XFile(result[0]["gpxPath"].toString()),
      XFile(result[0]["videoPath"].toString())
    ], text: 'Great picture')
        .then((value) {
      StorageService.deleteAppDir;
      StorageService.deleteCacheDir;
    });
  }

  void deleteDB(int id) async {
    if (await database.delete(Constants.databaseTableName,
            where: "id=?", whereArgs: [id]) !=
        0) {
      saveData = await returnDBData();
      update();
    }
  }
}
