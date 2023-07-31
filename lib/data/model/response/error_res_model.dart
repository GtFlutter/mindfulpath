class ErrorResponse {
  bool? status;
  String? message;

  ErrorResponse({this.status, this.message});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? false;
    message = json['message'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
