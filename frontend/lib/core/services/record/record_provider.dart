import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/services/api/api_service.dart';
import 'package:gogogame_frontend/core/types/match_record.dart';

// Provider for managing records
final recordProvider = StateNotifierProvider<RecordNotifier, List<MatchRecord>>(
  (ref) {
    return RecordNotifier(ref.read(apiService));
  },
);

class RecordNotifier extends StateNotifier<List<MatchRecord>> {
  final ApiService _apiService;

  RecordNotifier(this._apiService) : super([]) {
    fetchRecords(); // Fetch initial data when created
  }

  // Fetch initial records from API
  Future<void> fetchRecords() async {
    final res = await _apiService.get('matches');
    final json = jsonDecode(res.body);
    final data =
        (json as List).map((json) => MatchRecord.fromJson(json)).toList();
    state = data;
    log("Records fetched: ${state.length}");
  }

  // Add a new record (without refetching)
  void addRecord(MatchRecord newRecord) {
    state = [...state, newRecord];
  }
}
