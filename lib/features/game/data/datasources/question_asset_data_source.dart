import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/assets.dart';
import '../models/question_model.dart';

class QuestionAssetDataSource {
  QuestionAssetDataSource(this._bundle);

  final AssetBundle _bundle;

  Future<List<String>> categories() async {
    final manifest = await AssetManifest.loadFromAssetBundle(_bundle);
    return manifest
        .listAssets()
        .where((path) => path.startsWith(YqAssets.questionsDir) && path.endsWith('.json'))
        .map((path) => path.substring(YqAssets.questionsDir.length, path.length - '.json'.length))
        .toList()
      ..sort();
  }

  Future<List<QuestionModel>> questions(String category) async {
    final raw = await _bundle.loadString('${YqAssets.questionsDir}$category.json');
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
