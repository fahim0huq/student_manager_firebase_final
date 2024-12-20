// Model class
class Info {
  int? id;
  String? name;
  String? student_id;
  String? phone;
  String? email;
  String? location;

  // Constructor
  Info({
    this.id,
    this.name,
    this.student_id,
    this.phone,
    this.email,
    this.location,
  });

  // For saving data to DB (toMap)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'student_id': student_id,
      'phone': phone,
      'email': email,
      'location': location,
    };
  }

  // For retrieving data from DB (fromMap)
  static Info fromMap(Map<String, dynamic> map) {
    return Info(
      id: map['id'],
      name: map['name'],
      student_id: map['student_id'],
      phone: map['phone'],
      email: map['email'],
      location: map['location'],
    );
  }

  // For retrieving data from Firebase or DB (fromMap)
  static Info fromMapfb(Map<String, dynamic> map) {
    return Info(
      id: map['id'],
      name: map['name'],
      student_id: map['student_id'],
      phone: map['phone'],
      email: map['email'],
      location: map['location'],
    );
  }

  // Convert a list of maps (from Firebase) to a list of Info objects
  static List<Info> fromList(List<dynamic> list) {
    return list.map((item) => Info.fromMapfb(item as Map<String, dynamic>)).toList();
  }
}
