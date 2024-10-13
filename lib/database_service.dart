import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  Future addPersonalTask(
      Map<String, dynamic> userPersonalMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('personal')
        .doc(id)
        .set(userPersonalMap);
  }

  Future addUniversityTask(Map<String, dynamic> userUniTask, String id) async {
    return await FirebaseFirestore.instance
        .collection('university')
        .doc(id)
        .set(userUniTask);
  }

  Future addOfficeTask(Map<String, dynamic> userOfficeTask, String id) async {
    return await FirebaseFirestore.instance
        .collection('office')
        .doc(id)
        .set(userOfficeTask);
  }

  Future<Stream<QuerySnapshot>> fetchData(String task) async {
    return FirebaseFirestore.instance.collection(task).snapshots();
  }

  //tickMethod for completion
  tickMethod(String id, String task) async {
    return await FirebaseFirestore.instance.collection(task).doc(id).update({
      'isCompleted': true,
    });
  }

  deleteMethod(String id, String task) async {
    return await FirebaseFirestore.instance.collection(task).doc(id).delete();
  }
}
