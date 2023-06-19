import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';

import '../../common/ui/widgets/custom_snackbar.dart';
import 'models/supply_model.dart';
import 'supply_service.dart';

class SupplyController extends GetxController {
  final SupplyService _supplyService;
  final _loadingSaving = false.obs;
  final _loadingGetData = false.obs;
  final _supplies = <SupplyModel>[].obs;
  final _loadingDownloadFile = false.obs;

  SupplyController({
    required SupplyService supplyService,
  }) : _supplyService = supplyService;

  Future<void> insert({required SupplyModel supply}) async {
    try {
      loadingSaving = true;

      await _supplyService.insert(supply: supply);

      CustomSnackbar.show(
        Get.context!,
        message: 'Operação realizada com sucesso',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      CustomSnackbar.show(
        Get.context!,
        message: 'Erro ao informar valor pago',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      hideLoading();
    }
  }

  Future<List<SupplyModel>?> getAll({int? supplyIdApi, int? travelId, String? travelIdApi}) async {
    try {
      loadingGetData = true;

      final result = await _supplyService.getAll(
        supplyIdApi: supplyIdApi,
        travelId: travelId,
        travelIdApi: travelIdApi,
      );
      _supplies.value = result ?? <SupplyModel>[];
      return result;
    } catch (e) {
      CustomSnackbar.show(
        Get.context!,
        message: 'Erro ao buscar dados',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      throw Exception('Erro ao buscar dados');
    } finally {
      hideLoading();
    }
  }

  Future<String> uploadImage({
    required SupplyModel supply,
    required Uint8List image,
    required String typeImage,
  }) async {
    try {
      var result = await _supplyService.uploadImage(
        image: image,
        travelIdApi: supply.travelIdApi!,
        typeImage: typeImage,
      );
      return result;
    } catch (e) {
      log(e.toString());
      CustomSnackbar.show(
        Get.context!,
        message: 'Erro ao salvar dados',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      hideLoading();
      throw Exception('Erro ao salvar dados');
    }
  }

  Future<void> hideLoading() async {
    await Future.delayed(const Duration(seconds: 1)).then((value) {
      loadingSaving = false;
      loadingGetData = false;
      loadingDownloadFile = false;
    });
  }

  Future<File?> downloadFile({required String url}) async {
    try {
      loadingDownloadFile = true;
      final file = await FileDownloader.downloadFile(url: url);
      return file;
    } catch (e) {
      log(e.toString());
      CustomSnackbar.show(
        Get.context!,
        message: 'Erro ao baixar arquivo',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      throw Exception('Erro ao baixar arquivo');
    } finally {
      hideLoading();
    }
  }

  Future<void> sendSupply({required SupplyModel supply}) async {
    await _supplyService.sendSupply(supply: supply);
  }

  // Getters and Setters
  bool get loadingSaving => _loadingSaving.value;
  set loadingSaving(bool value) => _loadingSaving.value = value;

  bool get loadingGetData => _loadingGetData.value;
  set loadingGetData(bool value) => _loadingGetData.value = value;

  List<SupplyModel> get supplies => _supplies;

  bool get loadingDownloadFile => _loadingDownloadFile.value;

  set loadingDownloadFile(bool value) {
    _loadingDownloadFile.value = value;
  }
}
