class CreateResponse {
  String alias;
  Links links;

  CreateResponse({required this.alias, required this.links});

  factory CreateResponse.fromJson(Map<String, dynamic> json) => CreateResponse(
    alias: json["alias"],
    links: Links.fromJson(json["_links"]),
  );
}

class Links {
  String self;
  String short;

  Links({required this.self, required this.short});

  factory Links.fromJson(Map<String, dynamic> json) =>
      Links(self: json["self"], short: json["short"]);
}
