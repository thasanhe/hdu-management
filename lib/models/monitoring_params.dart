class MonitoringParameters {
  String id; //bht
  DateTime date;
  // Vent. Support
  double? fm; //FR l/min
  double? nrbm; //FR l/min

  double? hfnoFr; //FR l/min
  double? hfnoFiO2; //%

  double? bipapEpap; //mmH2O
  double? bipapIpap; //mmH2P
  double? bipapPs; //mmh2O
  double? bipapVt; //ml

  double? spO2; // %

  //ex
  double? bp; //mmHg
  double? pr; // /min

  double? wbc; // *10^3/uL
  double? n; // %
  double? hb; //g/dl
  double? plt; //*10^3
  double? crp; //mg/l
  double? sCr; //S.Cr micromol/l
  double? bu; //B.U mg/dl
  double? na; //mmol/l
  double? k; //mmol/l;
  double? ast; //u/l
  double? alt; //u/l
  double? pt; //s
  double? inr;
  double? ldh; //u/l
  double? procalcitonin; //ng/ml

  MonitoringParameters({
    required this.id,
    required this.date,
    this.fm,
    this.nrbm,
    this.hfnoFr,
    this.hfnoFiO2,
    this.bipapEpap,
    this.bipapIpap,
    this.bipapPs,
    this.bipapVt,
    this.spO2,
    this.bp,
    this.pr,
    this.wbc,
    this.n,
    this.hb,
    this.plt,
    this.crp,
    this.sCr,
    this.bu,
    this.na,
    this.k,
    this.ast,
    this.alt,
    this.pt,
    this.inr,
    this.ldh,
    this.procalcitonin,
  });
}
