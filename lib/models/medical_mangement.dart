class MedicalManagement {
  String id; //bht
  DateTime date;

  //antibiotics
  bool ivCeftrioxone2gd; //IV Ceftrioxone 2g/d
  bool ivpipTaz; //IV Pip-Taz
  MedicalManagement({
    required this.id,
    required this.date,
    required this.ivCeftrioxone2gd,
    required this.ivpipTaz,
  });
}
