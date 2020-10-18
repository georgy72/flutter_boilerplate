typedef ModelFactoryMethod<T> = T Function(dynamic value);

class ApiResponse<T> {
  final T data;
  final ApiErrors errors;
  int status;

  ApiResponse(this.data, this.errors, {this.status});

  get hasErrors => errors != null;
}

class ApiErrors {
  Map<String, dynamic> _errors;

  ApiErrors(Map<String, dynamic> errors) {
    this._errors = errors;
  }

  String getError() {
    return getErrors('detail');
  }

  String getErrors(String fieldName) {
    if (_errors == null || fieldName == null || fieldName.isEmpty) return null;
    final e = _errors[fieldName];
    if (e is String) return e;
    if (e is List && e.length > 0) return e.join(', ');
    return null;
  }

  setErrors(String fieldName, List errors) {
    if (_errors == null) return;
    _errors[fieldName] = errors != null && errors.length > 0 ? errors : null;
  }

  @override
  String toString() {
    final className = super.toString();
    if (_errors == null) return className;
    return '$className ( $_errors )';
  }
}
