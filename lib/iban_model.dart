import 'package:hive/hive.dart';

part 'iban_model.g.dart';

@HiveType(typeId: 0)

class IbanModel {

  @HiveField(0)
  final String ibanNo;
  @HiveField(1)
  final String ibanIsim;
  @HiveField(2)
  final bool isIbanBenim;

  IbanModel({this.ibanNo, this.ibanIsim, this.isIbanBenim});

}

