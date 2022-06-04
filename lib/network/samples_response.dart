import 'package:asmixer/network/sample_response.dart';

class SamplesResponse {
  final List<SampleResponse> samplesInfo;

  SamplesResponse(this.samplesInfo);

  factory SamplesResponse.fromJson(Map<String, dynamic> json) {
    List<SampleResponse> sampleResponse = [];
    json['samples'].forEach((v) {
      sampleResponse.add(SampleResponse.fromJson(v));
    });
    return SamplesResponse(sampleResponse);
  }
}
