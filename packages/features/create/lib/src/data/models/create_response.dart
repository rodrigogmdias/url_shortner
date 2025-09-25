import 'dart:convert';

class CreateResponse {
  String alias;
  Links links;

  CreateResponse({required this.alias, required this.links});

  factory CreateResponse.fromRawJson(String str) =>
      CreateResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateResponse.fromJson(Map<String, dynamic> json) => CreateResponse(
    alias: json["alias"],
    links: Links.fromJson(json["_links"]),
  );

  Map<String, dynamic> toJson() => {"alias": alias, "_links": links.toJson()};
}

class Links {
  String self;
  String short;

  Links({required this.self, required this.short});

  factory Links.fromRawJson(String str) => Links.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Links.fromJson(Map<String, dynamic> json) =>
      Links(self: json["self"], short: json["short"]);

  Map<String, dynamic> toJson() => {"self": self, "short": short};
}
