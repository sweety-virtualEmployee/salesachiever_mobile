// To parse this JSON data, do
//
//     final projectFormModel = projectFormModelFromJson(jsonString);

import 'dart:convert';

List<ProjectFormModel> projectFormModelFromJson(String str) => List<ProjectFormModel>.from(json.decode(str).map((x) => ProjectFormModel.fromJson(x)));

String projectFormModelToJson(List<ProjectFormModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProjectFormModel {
    ProjectFormModel({
        this.tableName,
        this.fieldName,
        this.fieldDesc,
        this.dislayOrder,
        this.formId,
        this.fieldType,
    });

    String ?tableName;
    String ?fieldName;
    String ?fieldDesc;
    String ?dislayOrder;
    String ?formId;
    String ?fieldType;

    factory ProjectFormModel.fromJson(Map<String, dynamic> json) => ProjectFormModel(
        tableName: json["TABLE_NAME"],
        fieldName: json["FIELD_NAME"],
        fieldDesc: json["FIELD_DESC"],
        dislayOrder: json["DISLAY_ORDER"],
        formId: json["FORM_ID"],
        fieldType: json["FIELD_TYPE"],
    );

    Map<String, dynamic> toJson() => {
        "TABLE_NAME": tableName,
        "FIELD_NAME": fieldName,
        "FIELD_DESC": fieldDesc,
        "DISLAY_ORDER": dislayOrder,
        "FORM_ID": formId,
        "FIELD_TYPE": fieldType,
    };
}
