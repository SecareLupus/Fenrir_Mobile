class HostMetrics {
  final int heartbeats;
  final double load1;
  final double load5;
  final double load15;
  final int activeSsh;

  HostMetrics({
    required this.heartbeats,
    required this.load1,
    required this.load5,
    required this.load15,
    required this.activeSsh,
  });

  factory HostMetrics.fromJson(Map<String, dynamic> json) {
    return HostMetrics(
      heartbeats: json['heartbeats'] ?? 0,
      load1: (json['load_1'] ?? 0.0).toDouble(),
      load5: (json['load_5'] ?? 0.0).toDouble(),
      load15: (json['load_15'] ?? 0.0).toDouble(),
      activeSsh: json['active_ssh'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'heartbeats': heartbeats,
      'load_1': load1,
      'load_5': load5,
      'load_15': load15,
      'active_ssh': activeSsh,
    };
  }
}
