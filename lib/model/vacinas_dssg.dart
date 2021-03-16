class VaccinesDSSG{
  String data;
  int doses;
  int doses_novas;
  int doses1;
  int doses1_novas;
  int doses2;
  int doses2_novas;
  
  VaccinesDSSG(this.data, this.doses, this.doses_novas, this.doses1, this.doses1_novas, this.doses2, this.doses2_novas);
  
  factory VaccinesDSSG.fromJson(Map<dynamic, dynamic> json){
    return VaccinesDSSG(json['data'], int.parse(json['doses']), int.parse(json['doses_novas']), int.parse(json['doses1']), int.parse(json['doses1_novas']), int.parse(json['doses2']), int.parse(json['doses2_novas']));
  }
}