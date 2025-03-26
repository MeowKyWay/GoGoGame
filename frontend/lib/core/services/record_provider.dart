import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/services/api_service.dart';
import 'package:gogogame_frontend/core/types/match_record.dart';

// Provider for managing records
final recordProvider = StateNotifierProvider<RecordNotifier, List<MatchRecord>>(
  (ref) {
    return RecordNotifier(ref.read(apiService));
  },
);

class RecordNotifier extends StateNotifier<List<MatchRecord>> {
  final ApiService _apiService;

  bool isLoading = true;

  RecordNotifier(this._apiService) : super([]) {
    fetchRecords(); // Fetch initial data when created
  }

  // Fetch initial records from API
  Future<void> fetchRecords() async {
    isLoading = true;
    final res = await _apiService.get('matches');
    final json = jsonDecode(res.body);
    final data =
        (json as List).map((json) => MatchRecord.fromJson(json)).toList();
    data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = data;
    isLoading = false;
  }

  // Add a new record (without refetching)
  void addRecord(MatchRecord newRecord) {
    state = [newRecord, ...state];
  }
}
