import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_yoga_fl/models/asana_model.dart';
import 'package:uuid/uuid.dart';

class ClassroomModel {
  final String id;
  final String title;
  final String description;
  final String coverImage;
  final int timeBetweenAsanas;
  final bool isPredefined;
  final List<AsanaModel> asanas;
  final Color color; // TODO: Remove property

  ClassroomModel({
    @required this.title,
    this.description,
    this.coverImage,
    this.asanas,
    this.color,
    this.timeBetweenAsanas = 300,
    this.isPredefined = false,
  }) : id = Uuid().v4();
}

var classrooms = [
  ClassroomModel(
    title: "Медитация",
    description:
        "Этот класс содержит всего одну асану, позу \"лотуса\" для практики медитации в неподвижном состоянии",
    coverImage: null,
    timeBetweenAsanas: 300,
    isPredefined: true,
    asanas: [
      AsanaModel(
        title: "Лотус",
        level: 2,
        imageUrl: null,
        description:
            "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga",
        warnings:
            "- At vero eos et accusamus et iusto odio \n- Dignissimos ducimus qui blanditiis praesentium voluptatum \n- Deleniti atque corrupti quos dolores",
      ),
    ],
    color: Colors.blueAccent[100],
  ),
  ClassroomModel(
    title: "Для бодрости",
    description: "Рекомендуем выполнять утром после пробуждения",
    coverImage: null,
    timeBetweenAsanas: 300,
    isPredefined: true,
    asanas: [
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
    ],
    color: Colors.pinkAccent[100],
  ),
  ClassroomModel(
    title: "Для молодых мам",
    description: "",
    coverImage: null,
    timeBetweenAsanas: 300,
    isPredefined: true,
    asanas: [
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
    ],
    color: Colors.orangeAccent[100],
  ),
];
