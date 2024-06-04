class ReportResponseModel<T> {
  final int code;
  final String status;
  final String message;
  final T? data;

  ReportResponseModel({
    required this.code,
    required this.status,
    required this.message,
    this.data,
  });

  factory ReportResponseModel.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return ReportResponseModel(
      code: json['code'],
      status: json['status'],
      message: json['message'],
      data: json['Data'] != null ? fromJsonT(json['Data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'message': message,
      'Data': data,
    };
  }
}
