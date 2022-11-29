import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gps_video_link/utils/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MainPageController extends GetxController {
  late Database database;

  bool pageLoading = true;

  List<Map<String, dynamic>> saveData = [];

  final TextEditingController projectNameTextEditingController =
      TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _controllerInit();
  }

  @override
  void onClose() {
    super.onClose();
    database.close();
    projectNameTextEditingController.dispose();
  }

  void _controllerInit() async {
    await _getDatabase();
    saveData = await _returnDBData();
    pageLoading = false;
    update();
  }

  Future<void> _getDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE ${Constants.databaseTableName}(id INTEGER PRIMARY KEY AUTOINCREMENT, projectName TEXT, createDateTime TEXT, gpxPath TEXT, videoPath TEXT)");
      },
      version: 1,
    );
  }

  Future<List<Map<String, Object?>>> _returnDBData() async {
    return await database.query(Constants.databaseTableName);
  }

  Future<void> getDBData() async {
    saveData = await database.query(Constants.databaseTableName);
    update();
  }

  void deleteDB(int id) async {
    List<Map<String, dynamic>> current =
        saveData.where((element) => element["id"] == id).toList();
    final videoPath = current.first["videoPath"];
    final gpxPath = current.first["gpxPath"];

    File(videoPath).delete();
    File(gpxPath).delete();

    if (await database.delete(Constants.databaseTableName,
            where: "id=?", whereArgs: [id]) !=
        0) {
      saveData = await _returnDBData();
      update();
    }
  }
}
