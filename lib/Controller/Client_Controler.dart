import 'package:appwrite/appwrite.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ClientController extends GetxController {
  Client client = Client();
  late Function() refreshCallback; // Ubah fungsi refreshCallback

  void setRefreshCallback(Function() callback) {
    refreshCallback = callback; // Atur fungsi callback
  }

  @override
  void onInit() {
    super.onInit();
// appwrite
    const endPoint = "https://cloud.appwrite.io/v1";
    const projectID = "65684aa8692ac77da3e5";
    client.setEndpoint(endPoint).setProject(projectID).setSelfSigned(status: true);
  }
}