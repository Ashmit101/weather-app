import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import '../data/geolocation.dart';

class SembastDb {
  DatabaseFactory dbFactory = databaseFactoryIo;
  Database? _db;

  final locationStore = intMapStoreFactory.store('location');
  final sideLocationStore = intMapStoreFactory.store('side_location');

  static SembastDb _singleton = SembastDb._internal();

  SembastDb._internal();

  factory SembastDb() {
    return _singleton;
  }

  Future<Database?> init() async {
    if (_db == null) {
      _db = await _openDb();
    }
    return _db;
  }

  Future _openDb() async {
    final docsDir = await getApplicationDocumentsDirectory();
    //make sure it exists
    await docsDir.create(recursive: true);
    final dbPath = join(docsDir.path, 'weather.db');
    final db = dbFactory.openDatabase(dbPath, version: 1);
    return db;
  }

  Future<int> addLocation(GeoLocation location) async {
    await init();
    int id = await locationStore.add(_db!, location.toMap());
    return id;
  }

  Future getLocation() async {
    await init();
    final snapshot = await locationStore.find(_db!);
    return snapshot.map((item) {
      final location = GeoLocation.fromMap(item.value);
      location.id = item.key;
      return location;
    }).toList();
  }

  Future updateLocation(GeoLocation geoLocation) async {
    final finder = Finder(filter: Filter.byKey(geoLocation.id));
    await locationStore.update(_db!, geoLocation.toMap(), finder: finder);
  }

  Future<int> addSideLocation(GeoLocation location) async {
    await init();
    int id = await sideLocationStore.add(_db!, location.toMap());
    return id;
  }

  Future getSideLocations() async {
    await init();
    final snapshot = await sideLocationStore.find(_db!);
    return snapshot.map((item) {
      final location = GeoLocation.fromMap(item.value);
      location.id = item.key;
      return location;
    }).toList();
  }
}
