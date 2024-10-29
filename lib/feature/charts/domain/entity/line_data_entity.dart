class LineDataEntity {
  String? pricedate;
  String? ticker;
  double? actualEps;
  double? estimatedEps;
  int? actualRevenue;
  int? estimatedRevenue;

  LineDataEntity(
      {this.pricedate,
      this.ticker,
      this.actualEps,
      this.estimatedEps,
      this.actualRevenue,
      this.estimatedRevenue});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pricedate'] = pricedate;
    data['ticker'] = ticker;
    data['actual_eps'] = actualEps;
    data['estimated_eps'] = estimatedEps;
    data['actual_revenue'] = actualRevenue;
    data['estimated_revenue'] = estimatedRevenue;
    return data;
  }
}
