import '../models/profile.dart';
import '../resources/resources.dart';
import '../services/api_provider.dart';
import '../utils/requests/requests.dart';

class AuthApiProvider {
  final HttpClient client;

  AuthApiProvider(this.client) : assert(client != null);

  Future<Profile> fetchProfile() async {
    return client.fetchItem(Constants.urls.profile, profileFactory);
  }

  Future<Profile> signIn(String username, String password) {
    final data = {'username': username, 'password': password};
    return authorize(data);
  }

  Future<Profile> authorize(Map<String, dynamic> data) async {
    return client.fetchItem(Constants.urls.auth, profileFactory, method: FetchMethod.post, body: data);
  }

  Profile profileFactory(item) {
    return Profile.fromJson(item);
  }
}
