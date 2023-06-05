import 'dart:typed_data';

import 'package:ailog_app_tracking/app/modules/travel/models/toll_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/repositories/travel_repository_database.dart';

import '../repositories/document_repository.dart';

class DocumentService {
  final DocumentRepository _documentRepository;
  final TravelRepositoryDatabase _travelRepositoryDatabase;

  DocumentService({
    required DocumentRepository documentRepository,
    required TravelRepositoryDatabase travelRepositoryDatabase,
  })  : _documentRepository = documentRepository,
        _travelRepositoryDatabase = travelRepositoryDatabase;

  Future<String> upload({required TollModel toll, required Uint8List image}) async {
    final imageUrl = await _documentRepository.uploadPhotoToll(
      toll: toll,
      image: image,
    );

    toll.urlVoucherImage = imageUrl;
    await _travelRepositoryDatabase.updateToll(toll: toll);

    return imageUrl;
  }
}
