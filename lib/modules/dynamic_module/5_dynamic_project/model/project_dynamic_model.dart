// To parse this JSON data, do
//
//     final dynamicProjectModel = dynamicProjectModelFromJson(jsonString);

import 'dart:convert';

List<DynamicProjectModel> dynamicProjectModelFromJson(String str) => List<DynamicProjectModel>.from(json.decode(str).map((x) => DynamicProjectModel.fromJson(x)));

String dynamicProjectModelToJson(List<DynamicProjectModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DynamicProjectModel {
  DynamicProjectModel({
    required this.tableName,
    required this.fieldName,
    required this.fieldDesc,
    required this.dislayOrder,
    required this.formId,
    required this.fieldType,
    required this.tableDesc,
    required this.col,
    required this.colval,
    required this.length,
    required this.mandatory,
  });

  Table tableName;
  String fieldName;
  String fieldDesc;
  String dislayOrder;
  FormId formId;
  String fieldType;
  Table tableDesc;
  String col;
  Colval colval;
  String length;
  Mandatory mandatory;

  factory DynamicProjectModel.fromJson(Map<String, dynamic> json) => DynamicProjectModel(
    tableName: tableValues.map[json["TABLE_NAME"]]!,
    fieldName: json["FIELD_NAME"],
    fieldDesc: json["FIELD_DESC"],
    dislayOrder: json["DISLAY_ORDER"],
    formId: formIdValues.map[json["FORM_ID"]]!,
    fieldType: json["FIELD_TYPE"],
    tableDesc: tableValues.map[json["TABLE_DESC"]]!,
    col: json["COL"],
    colval: colvalValues.map[json["COLVAL"]]!,
    length: json["LENGTH"],
    mandatory: mandatoryValues.map[json["Mandatory"]]!,
  );

  Map<String, dynamic> toJson() => {
    "TABLE_NAME": tableValues.reverse[tableName],
    "FIELD_NAME": fieldName,
    "FIELD_DESC": fieldDesc,
    "DISLAY_ORDER": dislayOrder,
    "FORM_ID": formIdValues.reverse[formId],
    "FIELD_TYPE": fieldType,
    "TABLE_DESC": tableValues.reverse[tableDesc],
    "COL": col,
    "COLVAL": colvalValues.reverse[colval],
    "LENGTH": length,
    "Mandatory": mandatoryValues.reverse[mandatory],
  };
}

enum Colval { TRUE }

final colvalValues = EnumValues({
  "True": Colval.TRUE
});

enum FormId { P001 }

final formIdValues = EnumValues({
  "P001": FormId.P001
});

enum Mandatory { N }

final mandatoryValues = EnumValues({
  "N": Mandatory.N
});

enum Table { PROJECT }

final tableValues = EnumValues({
  "PROJECT": Table.PROJECT
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
