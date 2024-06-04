class ApiResponse {
  int? code;
  String? status;
  String? message;
  List<ViolenceCategory>? data;

  ApiResponse({this.code, this.status, this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['Data'] as List<dynamic>?;
    return ApiResponse(
      code: json['code'] as int?,
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: dataList?.map((item) => ViolenceCategory.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'message': message,
      'Data': data?.map((v) => v.toJson()).toList(),
    };
  }
}


class ViolenceCategory {
  int? id;
  String? categoryName;
  String? image;
  String? createdAt;
  String? updatedAt;

  ViolenceCategory({this.id, this.categoryName, this.image, this.createdAt, this.updatedAt});

  factory ViolenceCategory.fromJson(Map<String, dynamic> json) {
    return ViolenceCategory(
      id: json['id'] as int? ?? 0,
      categoryName: json['category_name'] as String? ?? 'Kategori tidak diketahui',
      image: json['image'] as String? ?? '',
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_name': categoryName,
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

