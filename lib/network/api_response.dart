enum Status { LOADING, COMPLETED, ERROR }

class ApiResponse<T> {
  Status status;
  T? data;
  String message = "";
  int code;

  ApiResponse.loading([this.message = "", this.code = 0])
      : status = Status.LOADING;

  ApiResponse.completed(this.data, [this.code = 200])
      : status = Status.COMPLETED;

  ApiResponse.error(this.message, [this.code = 0]) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}
