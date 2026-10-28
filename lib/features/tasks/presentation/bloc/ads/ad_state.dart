enum AdStatus {
  loading,
  success,
  error,
}

class AdState {
  final AdStatus status;
  final List? data;
  final String? errorText;

  AdState({required this.status, this.data, this.errorText});

  AdState copyWith({
    AdStatus? status,
    List? data,
    String? errorText,
  }) {
    return AdState(
      status: status ?? this.status,
      errorText: errorText ?? this.errorText,
      data: data ?? this.data,
    );
  }


}