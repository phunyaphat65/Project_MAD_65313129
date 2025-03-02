import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart'; // ✅ เพิ่มการ import
import 'package:account/model/performanceItem.dart';
import 'package:account/database/performance_db.dart';

class PerformanceProvider with ChangeNotifier {
  final PerformanceDB _db = PerformanceDB(dbName: 'performances.db');
  List<PerformanceItem> _performances = [];

  List<PerformanceItem> get performances => List.unmodifiable(_performances);

  Future<void> initData() async {
    try {
      await refreshData();
    } catch (e) {
      debugPrint("❌ initData() ล้มเหลว: $e");
    }
  }

  Future<void> addPerformance(PerformanceItem performance) async {
    try {
      int newID = await _db.insertDatabase(performance);
      performance = performance.copyWith(keyID: newID);
      _performances.add(performance);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ เพิ่มข้อมูลล้มเหลว: $e");
    }
  }

  Future<void> deletePerformance(int keyID) async {
    try {
      await _db.deleteData(keyID);
      _performances.removeWhere((item) => item.keyID == keyID);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ ลบข้อมูลล้มเหลว: $e");
    }
  }

  Future<void> updatePerformance(PerformanceItem performance) async {
    try {
      await _db.updateData(performance);
      int index = _performances.indexWhere((item) => item.keyID == performance.keyID);
      if (index != -1) {
        _performances[index] = performance;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("❌ อัปเดตข้อมูลล้มเหลว: $e");
    }
  }

  Future<void> refreshData() async {
    try {
      List<PerformanceItem> newData = await _db.loadAllData();

      if (!const DeepCollectionEquality().equals(_performances, newData)) {
        debugPrint("🔄 โหลดข้อมูลใหม่ ${newData.length} รายการ");
        _performances = newData;
        notifyListeners();
      } else {
        debugPrint("✅ ข้อมูลยังเหมือนเดิม ไม่ต้องอัปเดต UI");
      }
    } catch (e) {
      debugPrint("❌ โหลดข้อมูลล้มเหลว: $e");
    }
  }
}
