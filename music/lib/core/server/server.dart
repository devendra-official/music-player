import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerCubit extends Cubit<String?> {
  ServerCubit(this.preferences) : super(preferences.getString("server"));

  final SharedPreferences preferences;
  static String serverIP = "http://192.168.193.48:8000";

  Future<void> updateServer(String address) async {
    await preferences.setString("server", address);
    String? server = preferences.getString("server");
    emit(server);
  }
}