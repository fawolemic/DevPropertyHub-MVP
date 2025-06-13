import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AddDevelopmentDraftService {
  static const _draftKey = 'add_dev_draft';

  static Future<void> saveDraft(Map<String, dynamic> draft) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_draftKey, jsonEncode(draft));
  }

  static Future<Map<String, dynamic>?> getDraft() async {
    final sp = await SharedPreferences.getInstance();
    final data = sp.getString(_draftKey);
    if (data != null) {
      return Map<String, dynamic>.from(jsonDecode(data) as Map);
    }
    return null;
  }

  static Future<bool> hasDraft() async {
    final sp = await SharedPreferences.getInstance();
    return sp.containsKey(_draftKey);
  }

  static Future<void> clearDraft() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_draftKey);
  }
}
