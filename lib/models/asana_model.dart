class AsanaModel {
  final String imageUrl;
  final String title;
  final double level;
  final String description;
  final String warnings;

  AsanaModel({this.imageUrl, this.title, this.level, this.description, this.warnings});
}

var asanas = [
  AsanaModel(
    title: "Собакен мордой вниз",
    level: 4.5,
    imageUrl: null,
    description:
        "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga",
    warnings:
        "- At vero eos et accusamus et iusto odio \n- Dignissimos ducimus qui blanditiis praesentium voluptatum \n- Deleniti atque corrupti quos dolores",
  ),
  AsanaModel(
    title: "Планка",
    level: 6.5,
    imageUrl: null,
    description:
        "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga",
    warnings:
        "- At vero eos et accusamus et iusto odio \n- Dignissimos ducimus qui blanditiis praesentium voluptatum \n- Deleniti atque corrupti quos dolores",
  ),
  AsanaModel(
    title: "Поза воина (правая сторона) пример пример пример пример",
    level: 3,
    imageUrl: null,
    description:
        "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga",
    warnings:
        "- At vero eos et accusamus et iusto odio \n- Dignissimos ducimus qui blanditiis praesentium voluptatum \n- Deleniti atque corrupti quos dolores",
  ),
  AsanaModel(
    title: "Воин 1 (левая сторона)",
    level: 6,
    imageUrl: null,
    description:
        "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga",
    warnings:
        "- At vero eos et accusamus et iusto odio \n- Dignissimos ducimus qui blanditiis praesentium voluptatum \n- Deleniti atque corrupti quos dolores",
  ),
];
