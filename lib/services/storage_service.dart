import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/trade_data.dart';

class StorageService {
  static const String _costPredictionsKey = 'cost_predictions';
  static const String _usageHistoryKey = 'usage_history';
  static const String _calculationsKey = 'calculations';
  static const String _tradeHistoryKey = 'trade_history';
  static const String _realTradeHistoryKey = 'real_trade_history';

  Future<void> saveCostPredictions(List<double> predictions) async {
    final prefs = await SharedPreferences.getInstance();
    final data = predictions.map((e) => e.toString()).toList();
    await prefs.setStringList(_costPredictionsKey, data);
  }

  Future<List<double>> getCostPredictions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_costPredictionsKey);
    if (data == null) return [];
    return data.map((e) => double.parse(e)).toList();
  }

  Future<void> saveCalculation(Map<String, dynamic> calculation) async {
    final prefs = await SharedPreferences.getInstance();
    final calculations = await getCalculations();
    calculations.add(calculation);
    
    // Keep only last 30 days of calculations
    if (calculations.length > 30) {
      calculations.removeAt(0);
    }
    
    await prefs.setString(_calculationsKey, jsonEncode(calculations));
  }

  Future<List<Map<String, dynamic>>> getCalculations() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_calculationsKey);
    if (data == null) return [];
    
    final List<dynamic> jsonData = jsonDecode(data);
    return jsonData.cast<Map<String, dynamic>>();
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> saveTradeData(TradeData trade) async {
    final prefs = await SharedPreferences.getInstance();
    final key = trade.isReal ? _realTradeHistoryKey : _tradeHistoryKey;
    final trades = await getTradeHistory(isReal: trade.isReal);
    
    // Convert trade to Map before storing
    final tradeJson = trade.toJson();
    
    // Get existing trades as list of maps
    List<Map<String, dynamic>> tradesJson = trades.map((t) => t.toJson()).toList();
    
    // Insert at beginning and maintain size limit
    tradesJson.insert(0, tradeJson);
    if (tradesJson.length > 100) tradesJson.removeLast();
    
    // Save the JSON string
    await prefs.setString(key, jsonEncode(tradesJson));
  }

  Future<List<TradeData>> getTradeHistory({bool isReal = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final key = isReal ? _realTradeHistoryKey : _tradeHistoryKey;
    final data = prefs.getString(key);
    
    if (data == null) return [];
    
    // Parse JSON and convert to TradeData objects
    final List<dynamic> jsonData = jsonDecode(data);
    return jsonData
        .cast<Map<String, dynamic>>()
        .map((json) => TradeData.fromJson(json))
        .toList();
  }

  Future<void> clearTradeHistory({bool isReal = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final key = isReal ? _realTradeHistoryKey : _tradeHistoryKey;
    await prefs.remove(key);
  }
}
