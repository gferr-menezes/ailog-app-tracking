import 'package:ailog_app_tracking/app/common/ui/widgets/custom_app_bar.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/address_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/models/travel_model.dart';
import 'package:ailog_app_tracking/app/modules/travel/widgets/form_occurrence.dart';
import 'package:flutter/material.dart';

class OccurrencePage extends StatelessWidget {
  const OccurrencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final TravelModel travel = args['travel'];
    final AddressModel? address = args['address'];

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FormOccurrence(travel: travel, address: address),
          ),
        ),
      ),
    );
  }
}
