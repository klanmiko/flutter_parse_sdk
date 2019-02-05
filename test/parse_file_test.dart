import 'package:test/test.dart';
import 'package:flutter/services.dart';
import '../lib/parse.dart';

class FileTest extends ParseObject implements ParseCloneable {

  FileTest() : super(_keyTableName);
  FileTest.clone(): this();

  /// Looks strangely hacky but due to Flutter not using reflection, we have to
  /// mimic a clone
  @override clone(Map map) => FileTest.clone()..fromJson(map);

  static const String _keyTableName = 'FileTest';
  static const String keyName = 'file';
  
  ParseFile get file => get<ParseFile>(keyName);
  set file(ParseFile file) => set<ParseFile>(keyName, file);
}

void main() {
  const MethodChannel('plugins.flutter.io/shared_preferences')
  .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{}; // set initial values here if desired
    }
    return null;
  });
  test('init ParseFile with null', () {
    Parse().initialize(null, null);
    var file = new ParseFile(null);
    expect(file.url, null);
    expect(file.file, null);
    expect(file.name, null);
  });
  test('download a file', () async {
    Parse().initialize("API NAME", "SERVER URL");
    var response = await FileTest().getAll();
    for(FileTest file in response.result){
      expect(file.file.name, isNotNull);
    }
  });
}