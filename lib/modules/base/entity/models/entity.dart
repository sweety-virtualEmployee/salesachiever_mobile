class EntityList {
  List<dynamic>? data;
  int pageNumber = 0;
  int pageSize = 15;
  bool isFirstPage = true;
  bool isLastPage = false;
  String? status;
  String? errorMessage;

  EntityList({
    this.data,
    this.pageNumber = 0,
    this.pageSize = 15,
    this.isFirstPage = true,
    this.isLastPage = false,
    this.status,
  });

  factory EntityList.fromJson(Map<String, dynamic> json) {
    var list = json['Items'] as List;

    return EntityList(
      data: list,
      pageNumber: json['PageNumber'],
      pageSize: json['PageSize'],
      isFirstPage: json['IsFirstPage'],
      isLastPage: json['IsLastPage'],
      status: json['Status'],
    );
  }

  EntityList.withError(String errorMessage) {
    this.errorMessage = errorMessage;
  }
}
