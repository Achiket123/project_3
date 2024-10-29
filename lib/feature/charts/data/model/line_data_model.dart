import 'package:project_3/feature/charts/domain/entity/line_data_entity.dart';

class LineDataModel extends LineDataEntity {
  LineDataModel(
      {required super.pricedate,
      required super.ticker,
      required super.actualEps,
      required super.estimatedEps,
      required super.actualRevenue,
      required super.estimatedRevenue});
  LineDataModel.fromJson(Map<String, dynamic> json) {
    pricedate = json['pricedate'] ?? '';
    ticker = json['ticker'] ?? '';
    actualEps = (json['actual_eps'] ?? 0).toDouble();
    estimatedEps = (json['estimated_eps'] ?? 0).toDouble();
    actualRevenue = (json['actual_revenue'] ?? 0);
    estimatedRevenue = json['estimated_revenue'] ?? 0;
  }
}
