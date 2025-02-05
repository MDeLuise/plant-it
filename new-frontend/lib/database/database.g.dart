// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $EventTypesTable extends EventTypes
    with TableInfo<$EventTypesTable, EventType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, icon, color, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_types';
  @override
  VerificationContext validateIntegrity(Insertable<EventType> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventType(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $EventTypesTable createAlias(String alias) {
    return $EventTypesTable(attachedDatabase, alias);
  }
}

class EventType extends DataClass implements Insertable<EventType> {
  final int id;
  final String name;
  final String? description;
  final String? icon;
  final String? color;
  final DateTime? createdAt;
  const EventType(
      {required this.id,
      required this.name,
      this.description,
      this.icon,
      this.color,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  EventTypesCompanion toCompanion(bool nullToAbsent) {
    return EventTypesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory EventType.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventType(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<String?>(json['color']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<String?>(color),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  EventType copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> icon = const Value.absent(),
          Value<String?> color = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent()}) =>
      EventType(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        icon: icon.present ? icon.value : this.icon,
        color: color.present ? color.value : this.color,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  EventType copyWithCompanion(EventTypesCompanion data) {
    return EventType(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventType(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, icon, color, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventType &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.createdAt == this.createdAt);
}

class EventTypesCompanion extends UpdateCompanion<EventType> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> icon;
  final Value<String?> color;
  final Value<DateTime?> createdAt;
  const EventTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EventTypesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<EventType> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EventTypesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? icon,
      Value<String?>? color,
      Value<DateTime?>? createdAt}) {
    return EventTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ImagesTable extends Images with TableInfo<$ImagesTable, Image> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _base64Meta = const VerificationMeta('base64');
  @override
  late final GeneratedColumn<String> base64 = GeneratedColumn<String>(
      'base64', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 250),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, base64, description, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'images';
  @override
  VerificationContext validateIntegrity(Insertable<Image> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('base64')) {
      context.handle(_base64Meta,
          base64.isAcceptableOrUnknown(data['base64']!, _base64Meta));
    } else if (isInserting) {
      context.missing(_base64Meta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Image map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Image(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      base64: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base64'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $ImagesTable createAlias(String alias) {
    return $ImagesTable(attachedDatabase, alias);
  }
}

class Image extends DataClass implements Insertable<Image> {
  final int id;
  final String base64;
  final String? description;
  final DateTime? createdAt;
  const Image(
      {required this.id,
      required this.base64,
      this.description,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['base64'] = Variable<String>(base64);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  ImagesCompanion toCompanion(bool nullToAbsent) {
    return ImagesCompanion(
      id: Value(id),
      base64: Value(base64),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory Image.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Image(
      id: serializer.fromJson<int>(json['id']),
      base64: serializer.fromJson<String>(json['base64']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'base64': serializer.toJson<String>(base64),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  Image copyWith(
          {int? id,
          String? base64,
          Value<String?> description = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent()}) =>
      Image(
        id: id ?? this.id,
        base64: base64 ?? this.base64,
        description: description.present ? description.value : this.description,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  Image copyWithCompanion(ImagesCompanion data) {
    return Image(
      id: data.id.present ? data.id.value : this.id,
      base64: data.base64.present ? data.base64.value : this.base64,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Image(')
          ..write('id: $id, ')
          ..write('base64: $base64, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, base64, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Image &&
          other.id == this.id &&
          other.base64 == this.base64 &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class ImagesCompanion extends UpdateCompanion<Image> {
  final Value<int> id;
  final Value<String> base64;
  final Value<String?> description;
  final Value<DateTime?> createdAt;
  const ImagesCompanion({
    this.id = const Value.absent(),
    this.base64 = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ImagesCompanion.insert({
    this.id = const Value.absent(),
    required String base64,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : base64 = Value(base64);
  static Insertable<Image> custom({
    Expression<int>? id,
    Expression<String>? base64,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (base64 != null) 'base64': base64,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ImagesCompanion copyWith(
      {Value<int>? id,
      Value<String>? base64,
      Value<String?>? description,
      Value<DateTime?>? createdAt}) {
    return ImagesCompanion(
      id: id ?? this.id,
      base64: base64 ?? this.base64,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (base64.present) {
      map['base64'] = Variable<String>(base64.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImagesCompanion(')
          ..write('id: $id, ')
          ..write('base64: $base64, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SpeciesTable extends Species with TableInfo<$SpeciesTable, Specy> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _scientificNameMeta =
      const VerificationMeta('scientificName');
  @override
  late final GeneratedColumn<String> scientificName = GeneratedColumn<String>(
      'scientific_name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _familyMeta = const VerificationMeta('family');
  @override
  late final GeneratedColumn<String> family = GeneratedColumn<String>(
      'family', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _genusMeta = const VerificationMeta('genus');
  @override
  late final GeneratedColumn<String> genus = GeneratedColumn<String>(
      'genus', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _speciesMeta =
      const VerificationMeta('species');
  @override
  late final GeneratedColumn<String> species = GeneratedColumn<String>(
      'species', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<int> avatar = GeneratedColumn<int>(
      'avatar', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES images (id) ON DELETE SET NULL'));
  static const VerificationMeta _avatarUrlMeta =
      const VerificationMeta('avatarUrl');
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
      'avatar_url', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 256),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _dataSourceMeta =
      const VerificationMeta('dataSource');
  @override
  late final GeneratedColumnWithTypeConverter<SpeciesDataSource, String>
      dataSource = GeneratedColumn<String>('data_source', aliasedName, false,
              additionalChecks:
                  GeneratedColumn.checkTextLength(maxTextLength: 50),
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant("custom"))
          .withConverter<SpeciesDataSource>($SpeciesTable.$converterdataSource);
  static const VerificationMeta _externalIdMeta =
      const VerificationMeta('externalId');
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
      'external_id', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 256),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _bibliographyMeta =
      const VerificationMeta('bibliography');
  @override
  late final GeneratedColumn<String> bibliography = GeneratedColumn<String>(
      'bibliography', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        scientificName,
        family,
        genus,
        species,
        author,
        avatar,
        avatarUrl,
        dataSource,
        externalId,
        year,
        bibliography
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'species';
  @override
  VerificationContext validateIntegrity(Insertable<Specy> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('scientific_name')) {
      context.handle(
          _scientificNameMeta,
          scientificName.isAcceptableOrUnknown(
              data['scientific_name']!, _scientificNameMeta));
    } else if (isInserting) {
      context.missing(_scientificNameMeta);
    }
    if (data.containsKey('family')) {
      context.handle(_familyMeta,
          family.isAcceptableOrUnknown(data['family']!, _familyMeta));
    } else if (isInserting) {
      context.missing(_familyMeta);
    }
    if (data.containsKey('genus')) {
      context.handle(
          _genusMeta, genus.isAcceptableOrUnknown(data['genus']!, _genusMeta));
    } else if (isInserting) {
      context.missing(_genusMeta);
    }
    if (data.containsKey('species')) {
      context.handle(_speciesMeta,
          species.isAcceptableOrUnknown(data['species']!, _speciesMeta));
    } else if (isInserting) {
      context.missing(_speciesMeta);
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
    }
    if (data.containsKey('avatar_url')) {
      context.handle(_avatarUrlMeta,
          avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta));
    }
    context.handle(_dataSourceMeta, const VerificationResult.success());
    if (data.containsKey('external_id')) {
      context.handle(
          _externalIdMeta,
          externalId.isAcceptableOrUnknown(
              data['external_id']!, _externalIdMeta));
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    }
    if (data.containsKey('bibliography')) {
      context.handle(
          _bibliographyMeta,
          bibliography.isAcceptableOrUnknown(
              data['bibliography']!, _bibliographyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Specy map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Specy(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      scientificName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}scientific_name'])!,
      family: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}family'])!,
      genus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}genus'])!,
      species: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}species'])!,
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author']),
      avatar: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}avatar']),
      avatarUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_url']),
      dataSource: $SpeciesTable.$converterdataSource.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data_source'])!),
      externalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}external_id']),
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year']),
      bibliography: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bibliography']),
    );
  }

  @override
  $SpeciesTable createAlias(String alias) {
    return $SpeciesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SpeciesDataSource, String, String>
      $converterdataSource =
      const EnumNameConverter<SpeciesDataSource>(SpeciesDataSource.values);
}

class Specy extends DataClass implements Insertable<Specy> {
  final int id;
  final String scientificName;
  final String family;
  final String genus;
  final String species;
  final String? author;
  final int? avatar;
  final String? avatarUrl;
  final SpeciesDataSource dataSource;
  final String? externalId;
  final int? year;
  final String? bibliography;
  const Specy(
      {required this.id,
      required this.scientificName,
      required this.family,
      required this.genus,
      required this.species,
      this.author,
      this.avatar,
      this.avatarUrl,
      required this.dataSource,
      this.externalId,
      this.year,
      this.bibliography});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['scientific_name'] = Variable<String>(scientificName);
    map['family'] = Variable<String>(family);
    map['genus'] = Variable<String>(genus);
    map['species'] = Variable<String>(species);
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<int>(avatar);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    {
      map['data_source'] = Variable<String>(
          $SpeciesTable.$converterdataSource.toSql(dataSource));
    }
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || bibliography != null) {
      map['bibliography'] = Variable<String>(bibliography);
    }
    return map;
  }

  SpeciesCompanion toCompanion(bool nullToAbsent) {
    return SpeciesCompanion(
      id: Value(id),
      scientificName: Value(scientificName),
      family: Value(family),
      genus: Value(genus),
      species: Value(species),
      author:
          author == null && nullToAbsent ? const Value.absent() : Value(author),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      dataSource: Value(dataSource),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      bibliography: bibliography == null && nullToAbsent
          ? const Value.absent()
          : Value(bibliography),
    );
  }

  factory Specy.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Specy(
      id: serializer.fromJson<int>(json['id']),
      scientificName: serializer.fromJson<String>(json['scientificName']),
      family: serializer.fromJson<String>(json['family']),
      genus: serializer.fromJson<String>(json['genus']),
      species: serializer.fromJson<String>(json['species']),
      author: serializer.fromJson<String?>(json['author']),
      avatar: serializer.fromJson<int?>(json['avatar']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      dataSource: $SpeciesTable.$converterdataSource
          .fromJson(serializer.fromJson<String>(json['dataSource'])),
      externalId: serializer.fromJson<String?>(json['externalId']),
      year: serializer.fromJson<int?>(json['year']),
      bibliography: serializer.fromJson<String?>(json['bibliography']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'scientificName': serializer.toJson<String>(scientificName),
      'family': serializer.toJson<String>(family),
      'genus': serializer.toJson<String>(genus),
      'species': serializer.toJson<String>(species),
      'author': serializer.toJson<String?>(author),
      'avatar': serializer.toJson<int?>(avatar),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'dataSource': serializer.toJson<String>(
          $SpeciesTable.$converterdataSource.toJson(dataSource)),
      'externalId': serializer.toJson<String?>(externalId),
      'year': serializer.toJson<int?>(year),
      'bibliography': serializer.toJson<String?>(bibliography),
    };
  }

  Specy copyWith(
          {int? id,
          String? scientificName,
          String? family,
          String? genus,
          String? species,
          Value<String?> author = const Value.absent(),
          Value<int?> avatar = const Value.absent(),
          Value<String?> avatarUrl = const Value.absent(),
          SpeciesDataSource? dataSource,
          Value<String?> externalId = const Value.absent(),
          Value<int?> year = const Value.absent(),
          Value<String?> bibliography = const Value.absent()}) =>
      Specy(
        id: id ?? this.id,
        scientificName: scientificName ?? this.scientificName,
        family: family ?? this.family,
        genus: genus ?? this.genus,
        species: species ?? this.species,
        author: author.present ? author.value : this.author,
        avatar: avatar.present ? avatar.value : this.avatar,
        avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
        dataSource: dataSource ?? this.dataSource,
        externalId: externalId.present ? externalId.value : this.externalId,
        year: year.present ? year.value : this.year,
        bibliography:
            bibliography.present ? bibliography.value : this.bibliography,
      );
  Specy copyWithCompanion(SpeciesCompanion data) {
    return Specy(
      id: data.id.present ? data.id.value : this.id,
      scientificName: data.scientificName.present
          ? data.scientificName.value
          : this.scientificName,
      family: data.family.present ? data.family.value : this.family,
      genus: data.genus.present ? data.genus.value : this.genus,
      species: data.species.present ? data.species.value : this.species,
      author: data.author.present ? data.author.value : this.author,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      dataSource:
          data.dataSource.present ? data.dataSource.value : this.dataSource,
      externalId:
          data.externalId.present ? data.externalId.value : this.externalId,
      year: data.year.present ? data.year.value : this.year,
      bibliography: data.bibliography.present
          ? data.bibliography.value
          : this.bibliography,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Specy(')
          ..write('id: $id, ')
          ..write('scientificName: $scientificName, ')
          ..write('family: $family, ')
          ..write('genus: $genus, ')
          ..write('species: $species, ')
          ..write('author: $author, ')
          ..write('avatar: $avatar, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('dataSource: $dataSource, ')
          ..write('externalId: $externalId, ')
          ..write('year: $year, ')
          ..write('bibliography: $bibliography')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, scientificName, family, genus, species,
      author, avatar, avatarUrl, dataSource, externalId, year, bibliography);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Specy &&
          other.id == this.id &&
          other.scientificName == this.scientificName &&
          other.family == this.family &&
          other.genus == this.genus &&
          other.species == this.species &&
          other.author == this.author &&
          other.avatar == this.avatar &&
          other.avatarUrl == this.avatarUrl &&
          other.dataSource == this.dataSource &&
          other.externalId == this.externalId &&
          other.year == this.year &&
          other.bibliography == this.bibliography);
}

class SpeciesCompanion extends UpdateCompanion<Specy> {
  final Value<int> id;
  final Value<String> scientificName;
  final Value<String> family;
  final Value<String> genus;
  final Value<String> species;
  final Value<String?> author;
  final Value<int?> avatar;
  final Value<String?> avatarUrl;
  final Value<SpeciesDataSource> dataSource;
  final Value<String?> externalId;
  final Value<int?> year;
  final Value<String?> bibliography;
  const SpeciesCompanion({
    this.id = const Value.absent(),
    this.scientificName = const Value.absent(),
    this.family = const Value.absent(),
    this.genus = const Value.absent(),
    this.species = const Value.absent(),
    this.author = const Value.absent(),
    this.avatar = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.dataSource = const Value.absent(),
    this.externalId = const Value.absent(),
    this.year = const Value.absent(),
    this.bibliography = const Value.absent(),
  });
  SpeciesCompanion.insert({
    this.id = const Value.absent(),
    required String scientificName,
    required String family,
    required String genus,
    required String species,
    this.author = const Value.absent(),
    this.avatar = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.dataSource = const Value.absent(),
    this.externalId = const Value.absent(),
    this.year = const Value.absent(),
    this.bibliography = const Value.absent(),
  })  : scientificName = Value(scientificName),
        family = Value(family),
        genus = Value(genus),
        species = Value(species);
  static Insertable<Specy> custom({
    Expression<int>? id,
    Expression<String>? scientificName,
    Expression<String>? family,
    Expression<String>? genus,
    Expression<String>? species,
    Expression<String>? author,
    Expression<int>? avatar,
    Expression<String>? avatarUrl,
    Expression<String>? dataSource,
    Expression<String>? externalId,
    Expression<int>? year,
    Expression<String>? bibliography,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scientificName != null) 'scientific_name': scientificName,
      if (family != null) 'family': family,
      if (genus != null) 'genus': genus,
      if (species != null) 'species': species,
      if (author != null) 'author': author,
      if (avatar != null) 'avatar': avatar,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (dataSource != null) 'data_source': dataSource,
      if (externalId != null) 'external_id': externalId,
      if (year != null) 'year': year,
      if (bibliography != null) 'bibliography': bibliography,
    });
  }

  SpeciesCompanion copyWith(
      {Value<int>? id,
      Value<String>? scientificName,
      Value<String>? family,
      Value<String>? genus,
      Value<String>? species,
      Value<String?>? author,
      Value<int?>? avatar,
      Value<String?>? avatarUrl,
      Value<SpeciesDataSource>? dataSource,
      Value<String?>? externalId,
      Value<int?>? year,
      Value<String?>? bibliography}) {
    return SpeciesCompanion(
      id: id ?? this.id,
      scientificName: scientificName ?? this.scientificName,
      family: family ?? this.family,
      genus: genus ?? this.genus,
      species: species ?? this.species,
      author: author ?? this.author,
      avatar: avatar ?? this.avatar,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dataSource: dataSource ?? this.dataSource,
      externalId: externalId ?? this.externalId,
      year: year ?? this.year,
      bibliography: bibliography ?? this.bibliography,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (scientificName.present) {
      map['scientific_name'] = Variable<String>(scientificName.value);
    }
    if (family.present) {
      map['family'] = Variable<String>(family.value);
    }
    if (genus.present) {
      map['genus'] = Variable<String>(genus.value);
    }
    if (species.present) {
      map['species'] = Variable<String>(species.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<int>(avatar.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (dataSource.present) {
      map['data_source'] = Variable<String>(
          $SpeciesTable.$converterdataSource.toSql(dataSource.value));
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (bibliography.present) {
      map['bibliography'] = Variable<String>(bibliography.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesCompanion(')
          ..write('id: $id, ')
          ..write('scientificName: $scientificName, ')
          ..write('family: $family, ')
          ..write('genus: $genus, ')
          ..write('species: $species, ')
          ..write('author: $author, ')
          ..write('avatar: $avatar, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('dataSource: $dataSource, ')
          ..write('externalId: $externalId, ')
          ..write('year: $year, ')
          ..write('bibliography: $bibliography')
          ..write(')'))
        .toString();
  }
}

class $PlantsTable extends Plants with TableInfo<$PlantsTable, Plant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 8500),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _speciesMeta =
      const VerificationMeta('species');
  @override
  late final GeneratedColumn<int> species = GeneratedColumn<int>(
      'species', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES species (id) ON DELETE CASCADE'));
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<int> avatar = GeneratedColumn<int>(
      'avatar', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES images (id) ON DELETE SET NULL'));
  static const VerificationMeta _avatarModeMeta =
      const VerificationMeta('avatarMode');
  @override
  late final GeneratedColumnWithTypeConverter<AvatarMode, String> avatarMode =
      GeneratedColumn<String>('avatar_mode', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant("none"))
          .withConverter<AvatarMode>($PlantsTable.$converteravatarMode);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, startDate, note, createdAt, species, avatar, avatarMode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plants';
  @override
  VerificationContext validateIntegrity(Insertable<Plant> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('species')) {
      context.handle(_speciesMeta,
          species.isAcceptableOrUnknown(data['species']!, _speciesMeta));
    } else if (isInserting) {
      context.missing(_speciesMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
    }
    context.handle(_avatarModeMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Plant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Plant(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      species: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}species'])!,
      avatar: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}avatar']),
      avatarMode: $PlantsTable.$converteravatarMode.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_mode'])!),
    );
  }

  @override
  $PlantsTable createAlias(String alias) {
    return $PlantsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AvatarMode, String, String> $converteravatarMode =
      const EnumNameConverter<AvatarMode>(AvatarMode.values);
}

class Plant extends DataClass implements Insertable<Plant> {
  final int id;
  final String name;
  final DateTime? startDate;
  final String? note;
  final DateTime? createdAt;
  final int species;
  final int? avatar;
  final AvatarMode avatarMode;
  const Plant(
      {required this.id,
      required this.name,
      this.startDate,
      this.note,
      this.createdAt,
      required this.species,
      this.avatar,
      required this.avatarMode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    map['species'] = Variable<int>(species);
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<int>(avatar);
    }
    {
      map['avatar_mode'] =
          Variable<String>($PlantsTable.$converteravatarMode.toSql(avatarMode));
    }
    return map;
  }

  PlantsCompanion toCompanion(bool nullToAbsent) {
    return PlantsCompanion(
      id: Value(id),
      name: Value(name),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      species: Value(species),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
      avatarMode: Value(avatarMode),
    );
  }

  factory Plant.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Plant(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      species: serializer.fromJson<int>(json['species']),
      avatar: serializer.fromJson<int?>(json['avatar']),
      avatarMode: $PlantsTable.$converteravatarMode
          .fromJson(serializer.fromJson<String>(json['avatarMode'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'species': serializer.toJson<int>(species),
      'avatar': serializer.toJson<int?>(avatar),
      'avatarMode': serializer
          .toJson<String>($PlantsTable.$converteravatarMode.toJson(avatarMode)),
    };
  }

  Plant copyWith(
          {int? id,
          String? name,
          Value<DateTime?> startDate = const Value.absent(),
          Value<String?> note = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          int? species,
          Value<int?> avatar = const Value.absent(),
          AvatarMode? avatarMode}) =>
      Plant(
        id: id ?? this.id,
        name: name ?? this.name,
        startDate: startDate.present ? startDate.value : this.startDate,
        note: note.present ? note.value : this.note,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        species: species ?? this.species,
        avatar: avatar.present ? avatar.value : this.avatar,
        avatarMode: avatarMode ?? this.avatarMode,
      );
  Plant copyWithCompanion(PlantsCompanion data) {
    return Plant(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      species: data.species.present ? data.species.value : this.species,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      avatarMode:
          data.avatarMode.present ? data.avatarMode.value : this.avatarMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Plant(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('species: $species, ')
          ..write('avatar: $avatar, ')
          ..write('avatarMode: $avatarMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, startDate, note, createdAt, species, avatar, avatarMode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Plant &&
          other.id == this.id &&
          other.name == this.name &&
          other.startDate == this.startDate &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.species == this.species &&
          other.avatar == this.avatar &&
          other.avatarMode == this.avatarMode);
}

class PlantsCompanion extends UpdateCompanion<Plant> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime?> startDate;
  final Value<String?> note;
  final Value<DateTime?> createdAt;
  final Value<int> species;
  final Value<int?> avatar;
  final Value<AvatarMode> avatarMode;
  const PlantsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.startDate = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.species = const Value.absent(),
    this.avatar = const Value.absent(),
    this.avatarMode = const Value.absent(),
  });
  PlantsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.startDate = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    required int species,
    this.avatar = const Value.absent(),
    this.avatarMode = const Value.absent(),
  })  : name = Value(name),
        species = Value(species);
  static Insertable<Plant> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? startDate,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? species,
    Expression<int>? avatar,
    Expression<String>? avatarMode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (startDate != null) 'start_date': startDate,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (species != null) 'species': species,
      if (avatar != null) 'avatar': avatar,
      if (avatarMode != null) 'avatar_mode': avatarMode,
    });
  }

  PlantsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<DateTime?>? startDate,
      Value<String?>? note,
      Value<DateTime?>? createdAt,
      Value<int>? species,
      Value<int?>? avatar,
      Value<AvatarMode>? avatarMode}) {
    return PlantsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      species: species ?? this.species,
      avatar: avatar ?? this.avatar,
      avatarMode: avatarMode ?? this.avatarMode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (species.present) {
      map['species'] = Variable<int>(species.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<int>(avatar.value);
    }
    if (avatarMode.present) {
      map['avatar_mode'] = Variable<String>(
          $PlantsTable.$converteravatarMode.toSql(avatarMode.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlantsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('species: $species, ')
          ..write('avatar: $avatar, ')
          ..write('avatarMode: $avatarMode')
          ..write(')'))
        .toString();
  }
}

class $SpeciesSynonymsTable extends SpeciesSynonyms
    with TableInfo<$SpeciesSynonymsTable, SpeciesSynonym> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeciesSynonymsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _speciesMeta =
      const VerificationMeta('species');
  @override
  late final GeneratedColumn<int> species = GeneratedColumn<int>(
      'species', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES species (id) ON DELETE CASCADE'));
  static const VerificationMeta _synonymMeta =
      const VerificationMeta('synonym');
  @override
  late final GeneratedColumn<String> synonym = GeneratedColumn<String>(
      'synonym', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, species, synonym];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'species_synonyms';
  @override
  VerificationContext validateIntegrity(Insertable<SpeciesSynonym> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('species')) {
      context.handle(_speciesMeta,
          species.isAcceptableOrUnknown(data['species']!, _speciesMeta));
    } else if (isInserting) {
      context.missing(_speciesMeta);
    }
    if (data.containsKey('synonym')) {
      context.handle(_synonymMeta,
          synonym.isAcceptableOrUnknown(data['synonym']!, _synonymMeta));
    } else if (isInserting) {
      context.missing(_synonymMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpeciesSynonym map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpeciesSynonym(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      species: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}species'])!,
      synonym: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}synonym'])!,
    );
  }

  @override
  $SpeciesSynonymsTable createAlias(String alias) {
    return $SpeciesSynonymsTable(attachedDatabase, alias);
  }
}

class SpeciesSynonym extends DataClass implements Insertable<SpeciesSynonym> {
  final int id;
  final int species;
  final String synonym;
  const SpeciesSynonym(
      {required this.id, required this.species, required this.synonym});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['species'] = Variable<int>(species);
    map['synonym'] = Variable<String>(synonym);
    return map;
  }

  SpeciesSynonymsCompanion toCompanion(bool nullToAbsent) {
    return SpeciesSynonymsCompanion(
      id: Value(id),
      species: Value(species),
      synonym: Value(synonym),
    );
  }

  factory SpeciesSynonym.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpeciesSynonym(
      id: serializer.fromJson<int>(json['id']),
      species: serializer.fromJson<int>(json['species']),
      synonym: serializer.fromJson<String>(json['synonym']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'species': serializer.toJson<int>(species),
      'synonym': serializer.toJson<String>(synonym),
    };
  }

  SpeciesSynonym copyWith({int? id, int? species, String? synonym}) =>
      SpeciesSynonym(
        id: id ?? this.id,
        species: species ?? this.species,
        synonym: synonym ?? this.synonym,
      );
  SpeciesSynonym copyWithCompanion(SpeciesSynonymsCompanion data) {
    return SpeciesSynonym(
      id: data.id.present ? data.id.value : this.id,
      species: data.species.present ? data.species.value : this.species,
      synonym: data.synonym.present ? data.synonym.value : this.synonym,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesSynonym(')
          ..write('id: $id, ')
          ..write('species: $species, ')
          ..write('synonym: $synonym')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, species, synonym);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpeciesSynonym &&
          other.id == this.id &&
          other.species == this.species &&
          other.synonym == this.synonym);
}

class SpeciesSynonymsCompanion extends UpdateCompanion<SpeciesSynonym> {
  final Value<int> id;
  final Value<int> species;
  final Value<String> synonym;
  const SpeciesSynonymsCompanion({
    this.id = const Value.absent(),
    this.species = const Value.absent(),
    this.synonym = const Value.absent(),
  });
  SpeciesSynonymsCompanion.insert({
    this.id = const Value.absent(),
    required int species,
    required String synonym,
  })  : species = Value(species),
        synonym = Value(synonym);
  static Insertable<SpeciesSynonym> custom({
    Expression<int>? id,
    Expression<int>? species,
    Expression<String>? synonym,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (species != null) 'species': species,
      if (synonym != null) 'synonym': synonym,
    });
  }

  SpeciesSynonymsCompanion copyWith(
      {Value<int>? id, Value<int>? species, Value<String>? synonym}) {
    return SpeciesSynonymsCompanion(
      id: id ?? this.id,
      species: species ?? this.species,
      synonym: synonym ?? this.synonym,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (species.present) {
      map['species'] = Variable<int>(species.value);
    }
    if (synonym.present) {
      map['synonym'] = Variable<String>(synonym.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesSynonymsCompanion(')
          ..write('id: $id, ')
          ..write('species: $species, ')
          ..write('synonym: $synonym')
          ..write(')'))
        .toString();
  }
}

class $SpeciesCareTable extends SpeciesCare
    with TableInfo<$SpeciesCareTable, SpeciesCareData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeciesCareTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _speciesMeta =
      const VerificationMeta('species');
  @override
  late final GeneratedColumn<int> species = GeneratedColumn<int>(
      'species', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES species (id) ON DELETE CASCADE'));
  static const VerificationMeta _lightMeta = const VerificationMeta('light');
  @override
  late final GeneratedColumn<int> light = GeneratedColumn<int>(
      'light', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _humidityMeta =
      const VerificationMeta('humidity');
  @override
  late final GeneratedColumn<int> humidity = GeneratedColumn<int>(
      'humidity', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _tempMaxMeta =
      const VerificationMeta('tempMax');
  @override
  late final GeneratedColumn<int> tempMax = GeneratedColumn<int>(
      'temp_max', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _tempMinMeta =
      const VerificationMeta('tempMin');
  @override
  late final GeneratedColumn<int> tempMin = GeneratedColumn<int>(
      'temp_min', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _phMinMeta = const VerificationMeta('phMin');
  @override
  late final GeneratedColumn<int> phMin = GeneratedColumn<int>(
      'ph_min', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _phMaxMeta = const VerificationMeta('phMax');
  @override
  late final GeneratedColumn<int> phMax = GeneratedColumn<int>(
      'ph_max', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [species, light, humidity, tempMax, tempMin, phMin, phMax];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'species_care';
  @override
  VerificationContext validateIntegrity(Insertable<SpeciesCareData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('species')) {
      context.handle(_speciesMeta,
          species.isAcceptableOrUnknown(data['species']!, _speciesMeta));
    }
    if (data.containsKey('light')) {
      context.handle(
          _lightMeta, light.isAcceptableOrUnknown(data['light']!, _lightMeta));
    }
    if (data.containsKey('humidity')) {
      context.handle(_humidityMeta,
          humidity.isAcceptableOrUnknown(data['humidity']!, _humidityMeta));
    }
    if (data.containsKey('temp_max')) {
      context.handle(_tempMaxMeta,
          tempMax.isAcceptableOrUnknown(data['temp_max']!, _tempMaxMeta));
    }
    if (data.containsKey('temp_min')) {
      context.handle(_tempMinMeta,
          tempMin.isAcceptableOrUnknown(data['temp_min']!, _tempMinMeta));
    }
    if (data.containsKey('ph_min')) {
      context.handle(
          _phMinMeta, phMin.isAcceptableOrUnknown(data['ph_min']!, _phMinMeta));
    }
    if (data.containsKey('ph_max')) {
      context.handle(
          _phMaxMeta, phMax.isAcceptableOrUnknown(data['ph_max']!, _phMaxMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {species};
  @override
  SpeciesCareData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpeciesCareData(
      species: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}species'])!,
      light: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}light']),
      humidity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}humidity']),
      tempMax: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}temp_max']),
      tempMin: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}temp_min']),
      phMin: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ph_min']),
      phMax: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ph_max']),
    );
  }

  @override
  $SpeciesCareTable createAlias(String alias) {
    return $SpeciesCareTable(attachedDatabase, alias);
  }
}

class SpeciesCareData extends DataClass implements Insertable<SpeciesCareData> {
  final int species;
  final int? light;
  final int? humidity;
  final int? tempMax;
  final int? tempMin;
  final int? phMin;
  final int? phMax;
  const SpeciesCareData(
      {required this.species,
      this.light,
      this.humidity,
      this.tempMax,
      this.tempMin,
      this.phMin,
      this.phMax});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['species'] = Variable<int>(species);
    if (!nullToAbsent || light != null) {
      map['light'] = Variable<int>(light);
    }
    if (!nullToAbsent || humidity != null) {
      map['humidity'] = Variable<int>(humidity);
    }
    if (!nullToAbsent || tempMax != null) {
      map['temp_max'] = Variable<int>(tempMax);
    }
    if (!nullToAbsent || tempMin != null) {
      map['temp_min'] = Variable<int>(tempMin);
    }
    if (!nullToAbsent || phMin != null) {
      map['ph_min'] = Variable<int>(phMin);
    }
    if (!nullToAbsent || phMax != null) {
      map['ph_max'] = Variable<int>(phMax);
    }
    return map;
  }

  SpeciesCareCompanion toCompanion(bool nullToAbsent) {
    return SpeciesCareCompanion(
      species: Value(species),
      light:
          light == null && nullToAbsent ? const Value.absent() : Value(light),
      humidity: humidity == null && nullToAbsent
          ? const Value.absent()
          : Value(humidity),
      tempMax: tempMax == null && nullToAbsent
          ? const Value.absent()
          : Value(tempMax),
      tempMin: tempMin == null && nullToAbsent
          ? const Value.absent()
          : Value(tempMin),
      phMin:
          phMin == null && nullToAbsent ? const Value.absent() : Value(phMin),
      phMax:
          phMax == null && nullToAbsent ? const Value.absent() : Value(phMax),
    );
  }

  factory SpeciesCareData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpeciesCareData(
      species: serializer.fromJson<int>(json['species']),
      light: serializer.fromJson<int?>(json['light']),
      humidity: serializer.fromJson<int?>(json['humidity']),
      tempMax: serializer.fromJson<int?>(json['tempMax']),
      tempMin: serializer.fromJson<int?>(json['tempMin']),
      phMin: serializer.fromJson<int?>(json['phMin']),
      phMax: serializer.fromJson<int?>(json['phMax']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'species': serializer.toJson<int>(species),
      'light': serializer.toJson<int?>(light),
      'humidity': serializer.toJson<int?>(humidity),
      'tempMax': serializer.toJson<int?>(tempMax),
      'tempMin': serializer.toJson<int?>(tempMin),
      'phMin': serializer.toJson<int?>(phMin),
      'phMax': serializer.toJson<int?>(phMax),
    };
  }

  SpeciesCareData copyWith(
          {int? species,
          Value<int?> light = const Value.absent(),
          Value<int?> humidity = const Value.absent(),
          Value<int?> tempMax = const Value.absent(),
          Value<int?> tempMin = const Value.absent(),
          Value<int?> phMin = const Value.absent(),
          Value<int?> phMax = const Value.absent()}) =>
      SpeciesCareData(
        species: species ?? this.species,
        light: light.present ? light.value : this.light,
        humidity: humidity.present ? humidity.value : this.humidity,
        tempMax: tempMax.present ? tempMax.value : this.tempMax,
        tempMin: tempMin.present ? tempMin.value : this.tempMin,
        phMin: phMin.present ? phMin.value : this.phMin,
        phMax: phMax.present ? phMax.value : this.phMax,
      );
  SpeciesCareData copyWithCompanion(SpeciesCareCompanion data) {
    return SpeciesCareData(
      species: data.species.present ? data.species.value : this.species,
      light: data.light.present ? data.light.value : this.light,
      humidity: data.humidity.present ? data.humidity.value : this.humidity,
      tempMax: data.tempMax.present ? data.tempMax.value : this.tempMax,
      tempMin: data.tempMin.present ? data.tempMin.value : this.tempMin,
      phMin: data.phMin.present ? data.phMin.value : this.phMin,
      phMax: data.phMax.present ? data.phMax.value : this.phMax,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesCareData(')
          ..write('species: $species, ')
          ..write('light: $light, ')
          ..write('humidity: $humidity, ')
          ..write('tempMax: $tempMax, ')
          ..write('tempMin: $tempMin, ')
          ..write('phMin: $phMin, ')
          ..write('phMax: $phMax')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(species, light, humidity, tempMax, tempMin, phMin, phMax);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpeciesCareData &&
          other.species == this.species &&
          other.light == this.light &&
          other.humidity == this.humidity &&
          other.tempMax == this.tempMax &&
          other.tempMin == this.tempMin &&
          other.phMin == this.phMin &&
          other.phMax == this.phMax);
}

class SpeciesCareCompanion extends UpdateCompanion<SpeciesCareData> {
  final Value<int> species;
  final Value<int?> light;
  final Value<int?> humidity;
  final Value<int?> tempMax;
  final Value<int?> tempMin;
  final Value<int?> phMin;
  final Value<int?> phMax;
  const SpeciesCareCompanion({
    this.species = const Value.absent(),
    this.light = const Value.absent(),
    this.humidity = const Value.absent(),
    this.tempMax = const Value.absent(),
    this.tempMin = const Value.absent(),
    this.phMin = const Value.absent(),
    this.phMax = const Value.absent(),
  });
  SpeciesCareCompanion.insert({
    this.species = const Value.absent(),
    this.light = const Value.absent(),
    this.humidity = const Value.absent(),
    this.tempMax = const Value.absent(),
    this.tempMin = const Value.absent(),
    this.phMin = const Value.absent(),
    this.phMax = const Value.absent(),
  });
  static Insertable<SpeciesCareData> custom({
    Expression<int>? species,
    Expression<int>? light,
    Expression<int>? humidity,
    Expression<int>? tempMax,
    Expression<int>? tempMin,
    Expression<int>? phMin,
    Expression<int>? phMax,
  }) {
    return RawValuesInsertable({
      if (species != null) 'species': species,
      if (light != null) 'light': light,
      if (humidity != null) 'humidity': humidity,
      if (tempMax != null) 'temp_max': tempMax,
      if (tempMin != null) 'temp_min': tempMin,
      if (phMin != null) 'ph_min': phMin,
      if (phMax != null) 'ph_max': phMax,
    });
  }

  SpeciesCareCompanion copyWith(
      {Value<int>? species,
      Value<int?>? light,
      Value<int?>? humidity,
      Value<int?>? tempMax,
      Value<int?>? tempMin,
      Value<int?>? phMin,
      Value<int?>? phMax}) {
    return SpeciesCareCompanion(
      species: species ?? this.species,
      light: light ?? this.light,
      humidity: humidity ?? this.humidity,
      tempMax: tempMax ?? this.tempMax,
      tempMin: tempMin ?? this.tempMin,
      phMin: phMin ?? this.phMin,
      phMax: phMax ?? this.phMax,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (species.present) {
      map['species'] = Variable<int>(species.value);
    }
    if (light.present) {
      map['light'] = Variable<int>(light.value);
    }
    if (humidity.present) {
      map['humidity'] = Variable<int>(humidity.value);
    }
    if (tempMax.present) {
      map['temp_max'] = Variable<int>(tempMax.value);
    }
    if (tempMin.present) {
      map['temp_min'] = Variable<int>(tempMin.value);
    }
    if (phMin.present) {
      map['ph_min'] = Variable<int>(phMin.value);
    }
    if (phMax.present) {
      map['ph_max'] = Variable<int>(phMax.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesCareCompanion(')
          ..write('species: $species, ')
          ..write('light: $light, ')
          ..write('humidity: $humidity, ')
          ..write('tempMax: $tempMax, ')
          ..write('tempMin: $tempMin, ')
          ..write('phMin: $phMin, ')
          ..write('phMax: $phMax')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
      'type', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES event_types (id) ON DELETE CASCADE'));
  static const VerificationMeta _plantMeta = const VerificationMeta('plant');
  @override
  late final GeneratedColumn<int> plant = GeneratedColumn<int>(
      'plant', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES plants (id) ON DELETE CASCADE'));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 250),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, type, plant, note, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(Insertable<Event> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('plant')) {
      context.handle(
          _plantMeta, plant.isAcceptableOrUnknown(data['plant']!, _plantMeta));
    } else if (isInserting) {
      context.missing(_plantMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!,
      plant: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plant'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class Event extends DataClass implements Insertable<Event> {
  final int id;
  final int type;
  final int plant;
  final String? note;
  final DateTime date;
  const Event(
      {required this.id,
      required this.type,
      required this.plant,
      this.note,
      required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<int>(type);
    map['plant'] = Variable<int>(plant);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      type: Value(type),
      plant: Value(plant),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      date: Value(date),
    );
  }

  factory Event.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<int>(json['type']),
      plant: serializer.fromJson<int>(json['plant']),
      note: serializer.fromJson<String?>(json['note']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<int>(type),
      'plant': serializer.toJson<int>(plant),
      'note': serializer.toJson<String?>(note),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  Event copyWith(
          {int? id,
          int? type,
          int? plant,
          Value<String?> note = const Value.absent(),
          DateTime? date}) =>
      Event(
        id: id ?? this.id,
        type: type ?? this.type,
        plant: plant ?? this.plant,
        note: note.present ? note.value : this.note,
        date: date ?? this.date,
      );
  Event copyWithCompanion(EventsCompanion data) {
    return Event(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      plant: data.plant.present ? data.plant.value : this.plant,
      note: data.note.present ? data.note.value : this.note,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('plant: $plant, ')
          ..write('note: $note, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, plant, note, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.type == this.type &&
          other.plant == this.plant &&
          other.note == this.note &&
          other.date == this.date);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<int> id;
  final Value<int> type;
  final Value<int> plant;
  final Value<String?> note;
  final Value<DateTime> date;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.plant = const Value.absent(),
    this.note = const Value.absent(),
    this.date = const Value.absent(),
  });
  EventsCompanion.insert({
    this.id = const Value.absent(),
    required int type,
    required int plant,
    this.note = const Value.absent(),
    required DateTime date,
  })  : type = Value(type),
        plant = Value(plant),
        date = Value(date);
  static Insertable<Event> custom({
    Expression<int>? id,
    Expression<int>? type,
    Expression<int>? plant,
    Expression<String>? note,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (plant != null) 'plant': plant,
      if (note != null) 'note': note,
      if (date != null) 'date': date,
    });
  }

  EventsCompanion copyWith(
      {Value<int>? id,
      Value<int>? type,
      Value<int>? plant,
      Value<String?>? note,
      Value<DateTime>? date}) {
    return EventsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      plant: plant ?? this.plant,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (plant.present) {
      map['plant'] = Variable<int>(plant.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('plant: $plant, ')
          ..write('note: $note, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
      'type', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES event_types (id) ON DELETE CASCADE'));
  static const VerificationMeta _plantMeta = const VerificationMeta('plant');
  @override
  late final GeneratedColumn<int> plant = GeneratedColumn<int>(
      'plant', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES plants (id) ON DELETE CASCADE'));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _frequencyUnitMeta =
      const VerificationMeta('frequencyUnit');
  @override
  late final GeneratedColumnWithTypeConverter<FrequencyUnit, String>
      frequencyUnit = GeneratedColumn<String>(
              'frequency_unit', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<FrequencyUnit>(
              $RemindersTable.$converterfrequencyUnit);
  static const VerificationMeta _frequencyQuantityMeta =
      const VerificationMeta('frequencyQuantity');
  @override
  late final GeneratedColumn<int> frequencyQuantity = GeneratedColumn<int>(
      'frequency_quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _repeatAfterUnitMeta =
      const VerificationMeta('repeatAfterUnit');
  @override
  late final GeneratedColumnWithTypeConverter<FrequencyUnit, String>
      repeatAfterUnit = GeneratedColumn<String>(
              'repeat_after_unit', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<FrequencyUnit>(
              $RemindersTable.$converterrepeatAfterUnit);
  static const VerificationMeta _repeatAfterQuantityMeta =
      const VerificationMeta('repeatAfterQuantity');
  @override
  late final GeneratedColumn<int> repeatAfterQuantity = GeneratedColumn<int>(
      'repeat_after_quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastNotifiedMeta =
      const VerificationMeta('lastNotified');
  @override
  late final GeneratedColumn<DateTime> lastNotified = GeneratedColumn<DateTime>(
      'last_notified', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        type,
        plant,
        startDate,
        endDate,
        frequencyUnit,
        frequencyQuantity,
        repeatAfterUnit,
        repeatAfterQuantity,
        lastNotified,
        enabled
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(Insertable<Reminder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('plant')) {
      context.handle(
          _plantMeta, plant.isAcceptableOrUnknown(data['plant']!, _plantMeta));
    } else if (isInserting) {
      context.missing(_plantMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    context.handle(_frequencyUnitMeta, const VerificationResult.success());
    if (data.containsKey('frequency_quantity')) {
      context.handle(
          _frequencyQuantityMeta,
          frequencyQuantity.isAcceptableOrUnknown(
              data['frequency_quantity']!, _frequencyQuantityMeta));
    } else if (isInserting) {
      context.missing(_frequencyQuantityMeta);
    }
    context.handle(_repeatAfterUnitMeta, const VerificationResult.success());
    if (data.containsKey('repeat_after_quantity')) {
      context.handle(
          _repeatAfterQuantityMeta,
          repeatAfterQuantity.isAcceptableOrUnknown(
              data['repeat_after_quantity']!, _repeatAfterQuantityMeta));
    } else if (isInserting) {
      context.missing(_repeatAfterQuantityMeta);
    }
    if (data.containsKey('last_notified')) {
      context.handle(
          _lastNotifiedMeta,
          lastNotified.isAcceptableOrUnknown(
              data['last_notified']!, _lastNotifiedMeta));
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    } else if (isInserting) {
      context.missing(_enabledMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!,
      plant: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plant'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      frequencyUnit: $RemindersTable.$converterfrequencyUnit.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}frequency_unit'])!),
      frequencyQuantity: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}frequency_quantity'])!,
      repeatAfterUnit: $RemindersTable.$converterrepeatAfterUnit.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}repeat_after_unit'])!),
      repeatAfterQuantity: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}repeat_after_quantity'])!,
      lastNotified: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_notified']),
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FrequencyUnit, String, String>
      $converterfrequencyUnit =
      const EnumNameConverter<FrequencyUnit>(FrequencyUnit.values);
  static JsonTypeConverter2<FrequencyUnit, String, String>
      $converterrepeatAfterUnit =
      const EnumNameConverter<FrequencyUnit>(FrequencyUnit.values);
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;
  final int type;
  final int plant;
  final DateTime startDate;
  final DateTime? endDate;
  final FrequencyUnit frequencyUnit;
  final int frequencyQuantity;
  final FrequencyUnit repeatAfterUnit;
  final int repeatAfterQuantity;
  final DateTime? lastNotified;
  final bool enabled;
  const Reminder(
      {required this.id,
      required this.type,
      required this.plant,
      required this.startDate,
      this.endDate,
      required this.frequencyUnit,
      required this.frequencyQuantity,
      required this.repeatAfterUnit,
      required this.repeatAfterQuantity,
      this.lastNotified,
      required this.enabled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<int>(type);
    map['plant'] = Variable<int>(plant);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    {
      map['frequency_unit'] = Variable<String>(
          $RemindersTable.$converterfrequencyUnit.toSql(frequencyUnit));
    }
    map['frequency_quantity'] = Variable<int>(frequencyQuantity);
    {
      map['repeat_after_unit'] = Variable<String>(
          $RemindersTable.$converterrepeatAfterUnit.toSql(repeatAfterUnit));
    }
    map['repeat_after_quantity'] = Variable<int>(repeatAfterQuantity);
    if (!nullToAbsent || lastNotified != null) {
      map['last_notified'] = Variable<DateTime>(lastNotified);
    }
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      type: Value(type),
      plant: Value(plant),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      frequencyUnit: Value(frequencyUnit),
      frequencyQuantity: Value(frequencyQuantity),
      repeatAfterUnit: Value(repeatAfterUnit),
      repeatAfterQuantity: Value(repeatAfterQuantity),
      lastNotified: lastNotified == null && nullToAbsent
          ? const Value.absent()
          : Value(lastNotified),
      enabled: Value(enabled),
    );
  }

  factory Reminder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<int>(json['type']),
      plant: serializer.fromJson<int>(json['plant']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      frequencyUnit: $RemindersTable.$converterfrequencyUnit
          .fromJson(serializer.fromJson<String>(json['frequencyUnit'])),
      frequencyQuantity: serializer.fromJson<int>(json['frequencyQuantity']),
      repeatAfterUnit: $RemindersTable.$converterrepeatAfterUnit
          .fromJson(serializer.fromJson<String>(json['repeatAfterUnit'])),
      repeatAfterQuantity:
          serializer.fromJson<int>(json['repeatAfterQuantity']),
      lastNotified: serializer.fromJson<DateTime?>(json['lastNotified']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<int>(type),
      'plant': serializer.toJson<int>(plant),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'frequencyUnit': serializer.toJson<String>(
          $RemindersTable.$converterfrequencyUnit.toJson(frequencyUnit)),
      'frequencyQuantity': serializer.toJson<int>(frequencyQuantity),
      'repeatAfterUnit': serializer.toJson<String>(
          $RemindersTable.$converterrepeatAfterUnit.toJson(repeatAfterUnit)),
      'repeatAfterQuantity': serializer.toJson<int>(repeatAfterQuantity),
      'lastNotified': serializer.toJson<DateTime?>(lastNotified),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  Reminder copyWith(
          {int? id,
          int? type,
          int? plant,
          DateTime? startDate,
          Value<DateTime?> endDate = const Value.absent(),
          FrequencyUnit? frequencyUnit,
          int? frequencyQuantity,
          FrequencyUnit? repeatAfterUnit,
          int? repeatAfterQuantity,
          Value<DateTime?> lastNotified = const Value.absent(),
          bool? enabled}) =>
      Reminder(
        id: id ?? this.id,
        type: type ?? this.type,
        plant: plant ?? this.plant,
        startDate: startDate ?? this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        frequencyUnit: frequencyUnit ?? this.frequencyUnit,
        frequencyQuantity: frequencyQuantity ?? this.frequencyQuantity,
        repeatAfterUnit: repeatAfterUnit ?? this.repeatAfterUnit,
        repeatAfterQuantity: repeatAfterQuantity ?? this.repeatAfterQuantity,
        lastNotified:
            lastNotified.present ? lastNotified.value : this.lastNotified,
        enabled: enabled ?? this.enabled,
      );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      plant: data.plant.present ? data.plant.value : this.plant,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      frequencyUnit: data.frequencyUnit.present
          ? data.frequencyUnit.value
          : this.frequencyUnit,
      frequencyQuantity: data.frequencyQuantity.present
          ? data.frequencyQuantity.value
          : this.frequencyQuantity,
      repeatAfterUnit: data.repeatAfterUnit.present
          ? data.repeatAfterUnit.value
          : this.repeatAfterUnit,
      repeatAfterQuantity: data.repeatAfterQuantity.present
          ? data.repeatAfterQuantity.value
          : this.repeatAfterQuantity,
      lastNotified: data.lastNotified.present
          ? data.lastNotified.value
          : this.lastNotified,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('plant: $plant, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('frequencyUnit: $frequencyUnit, ')
          ..write('frequencyQuantity: $frequencyQuantity, ')
          ..write('repeatAfterUnit: $repeatAfterUnit, ')
          ..write('repeatAfterQuantity: $repeatAfterQuantity, ')
          ..write('lastNotified: $lastNotified, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      type,
      plant,
      startDate,
      endDate,
      frequencyUnit,
      frequencyQuantity,
      repeatAfterUnit,
      repeatAfterQuantity,
      lastNotified,
      enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.type == this.type &&
          other.plant == this.plant &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.frequencyUnit == this.frequencyUnit &&
          other.frequencyQuantity == this.frequencyQuantity &&
          other.repeatAfterUnit == this.repeatAfterUnit &&
          other.repeatAfterQuantity == this.repeatAfterQuantity &&
          other.lastNotified == this.lastNotified &&
          other.enabled == this.enabled);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<int> type;
  final Value<int> plant;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<FrequencyUnit> frequencyUnit;
  final Value<int> frequencyQuantity;
  final Value<FrequencyUnit> repeatAfterUnit;
  final Value<int> repeatAfterQuantity;
  final Value<DateTime?> lastNotified;
  final Value<bool> enabled;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.plant = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.frequencyUnit = const Value.absent(),
    this.frequencyQuantity = const Value.absent(),
    this.repeatAfterUnit = const Value.absent(),
    this.repeatAfterQuantity = const Value.absent(),
    this.lastNotified = const Value.absent(),
    this.enabled = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required int type,
    required int plant,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    required FrequencyUnit frequencyUnit,
    required int frequencyQuantity,
    required FrequencyUnit repeatAfterUnit,
    required int repeatAfterQuantity,
    this.lastNotified = const Value.absent(),
    required bool enabled,
  })  : type = Value(type),
        plant = Value(plant),
        startDate = Value(startDate),
        frequencyUnit = Value(frequencyUnit),
        frequencyQuantity = Value(frequencyQuantity),
        repeatAfterUnit = Value(repeatAfterUnit),
        repeatAfterQuantity = Value(repeatAfterQuantity),
        enabled = Value(enabled);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<int>? type,
    Expression<int>? plant,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? frequencyUnit,
    Expression<int>? frequencyQuantity,
    Expression<String>? repeatAfterUnit,
    Expression<int>? repeatAfterQuantity,
    Expression<DateTime>? lastNotified,
    Expression<bool>? enabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (plant != null) 'plant': plant,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (frequencyUnit != null) 'frequency_unit': frequencyUnit,
      if (frequencyQuantity != null) 'frequency_quantity': frequencyQuantity,
      if (repeatAfterUnit != null) 'repeat_after_unit': repeatAfterUnit,
      if (repeatAfterQuantity != null)
        'repeat_after_quantity': repeatAfterQuantity,
      if (lastNotified != null) 'last_notified': lastNotified,
      if (enabled != null) 'enabled': enabled,
    });
  }

  RemindersCompanion copyWith(
      {Value<int>? id,
      Value<int>? type,
      Value<int>? plant,
      Value<DateTime>? startDate,
      Value<DateTime?>? endDate,
      Value<FrequencyUnit>? frequencyUnit,
      Value<int>? frequencyQuantity,
      Value<FrequencyUnit>? repeatAfterUnit,
      Value<int>? repeatAfterQuantity,
      Value<DateTime?>? lastNotified,
      Value<bool>? enabled}) {
    return RemindersCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      plant: plant ?? this.plant,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      frequencyUnit: frequencyUnit ?? this.frequencyUnit,
      frequencyQuantity: frequencyQuantity ?? this.frequencyQuantity,
      repeatAfterUnit: repeatAfterUnit ?? this.repeatAfterUnit,
      repeatAfterQuantity: repeatAfterQuantity ?? this.repeatAfterQuantity,
      lastNotified: lastNotified ?? this.lastNotified,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (plant.present) {
      map['plant'] = Variable<int>(plant.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (frequencyUnit.present) {
      map['frequency_unit'] = Variable<String>(
          $RemindersTable.$converterfrequencyUnit.toSql(frequencyUnit.value));
    }
    if (frequencyQuantity.present) {
      map['frequency_quantity'] = Variable<int>(frequencyQuantity.value);
    }
    if (repeatAfterUnit.present) {
      map['repeat_after_unit'] = Variable<String>($RemindersTable
          .$converterrepeatAfterUnit
          .toSql(repeatAfterUnit.value));
    }
    if (repeatAfterQuantity.present) {
      map['repeat_after_quantity'] = Variable<int>(repeatAfterQuantity.value);
    }
    if (lastNotified.present) {
      map['last_notified'] = Variable<DateTime>(lastNotified.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('plant: $plant, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('frequencyUnit: $frequencyUnit, ')
          ..write('frequencyQuantity: $frequencyQuantity, ')
          ..write('repeatAfterUnit: $repeatAfterUnit, ')
          ..write('repeatAfterQuantity: $repeatAfterQuantity, ')
          ..write('lastNotified: $lastNotified, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTable extends UserSettings
    with TableInfo<$UserSettingsTable, UserSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(Insertable<UserSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  UserSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSetting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $UserSettingsTable createAlias(String alias) {
    return $UserSettingsTable(attachedDatabase, alias);
  }
}

class UserSetting extends DataClass implements Insertable<UserSetting> {
  final String key;
  final String value;
  const UserSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  UserSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory UserSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  UserSetting copyWith({String? key, String? value}) => UserSetting(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  UserSetting copyWithCompanion(UserSettingsCompanion data) {
    return UserSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class UserSettingsCompanion extends UpdateCompanion<UserSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const UserSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<UserSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSettingsCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return UserSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EventTypesTable eventTypes = $EventTypesTable(this);
  late final $ImagesTable images = $ImagesTable(this);
  late final $SpeciesTable species = $SpeciesTable(this);
  late final $PlantsTable plants = $PlantsTable(this);
  late final $SpeciesSynonymsTable speciesSynonyms =
      $SpeciesSynonymsTable(this);
  late final $SpeciesCareTable speciesCare = $SpeciesCareTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        eventTypes,
        images,
        species,
        plants,
        speciesSynonyms,
        speciesCare,
        events,
        reminders,
        userSettings
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('images',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('species', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('species',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('plants', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('images',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('plants', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('species',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('species_synonyms', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('species',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('species_care', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('event_types',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('events', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('plants',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('events', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('event_types',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('reminders', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('plants',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('reminders', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$EventTypesTableCreateCompanionBuilder = EventTypesCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> description,
  Value<String?> icon,
  Value<String?> color,
  Value<DateTime?> createdAt,
});
typedef $$EventTypesTableUpdateCompanionBuilder = EventTypesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<String?> icon,
  Value<String?> color,
  Value<DateTime?> createdAt,
});

final class $$EventTypesTableReferences
    extends BaseReferences<_$AppDatabase, $EventTypesTable, EventType> {
  $$EventTypesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EventsTable, List<Event>> _eventsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.events,
          aliasName: $_aliasNameGenerator(db.eventTypes.id, db.events.type));

  $$EventsTableProcessedTableManager get eventsRefs {
    final manager = $$EventsTableTableManager($_db, $_db.events)
        .filter((f) => f.type.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_eventsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RemindersTable, List<Reminder>>
      _remindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.reminders,
          aliasName: $_aliasNameGenerator(db.eventTypes.id, db.reminders.type));

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager($_db, $_db.reminders)
        .filter((f) => f.type.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EventTypesTableFilterComposer
    extends Composer<_$AppDatabase, $EventTypesTable> {
  $$EventTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> eventsRefs(
      Expression<bool> Function($$EventsTableFilterComposer f) f) {
    final $$EventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.type,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableFilterComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> remindersRefs(
      Expression<bool> Function($$RemindersTableFilterComposer f) f) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reminders,
        getReferencedColumn: (t) => t.type,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableFilterComposer(
              $db: $db,
              $table: $db.reminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EventTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $EventTypesTable> {
  $$EventTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$EventTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventTypesTable> {
  $$EventTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> eventsRefs<T extends Object>(
      Expression<T> Function($$EventsTableAnnotationComposer a) f) {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.type,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableAnnotationComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> remindersRefs<T extends Object>(
      Expression<T> Function($$RemindersTableAnnotationComposer a) f) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reminders,
        getReferencedColumn: (t) => t.type,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableAnnotationComposer(
              $db: $db,
              $table: $db.reminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EventTypesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EventTypesTable,
    EventType,
    $$EventTypesTableFilterComposer,
    $$EventTypesTableOrderingComposer,
    $$EventTypesTableAnnotationComposer,
    $$EventTypesTableCreateCompanionBuilder,
    $$EventTypesTableUpdateCompanionBuilder,
    (EventType, $$EventTypesTableReferences),
    EventType,
    PrefetchHooks Function({bool eventsRefs, bool remindersRefs})> {
  $$EventTypesTableTableManager(_$AppDatabase db, $EventTypesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              EventTypesCompanion(
            id: id,
            name: name,
            description: description,
            icon: icon,
            color: color,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              EventTypesCompanion.insert(
            id: id,
            name: name,
            description: description,
            icon: icon,
            color: color,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EventTypesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({eventsRefs = false, remindersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (eventsRefs) db.events,
                if (remindersRefs) db.reminders
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (eventsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$EventTypesTableReferences._eventsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EventTypesTableReferences(db, table, p0)
                                .eventsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) =>
                                referencedItems.where((e) => e.type == item.id),
                        typedResults: items),
                  if (remindersRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$EventTypesTableReferences._remindersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EventTypesTableReferences(db, table, p0)
                                .remindersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) =>
                                referencedItems.where((e) => e.type == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EventTypesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EventTypesTable,
    EventType,
    $$EventTypesTableFilterComposer,
    $$EventTypesTableOrderingComposer,
    $$EventTypesTableAnnotationComposer,
    $$EventTypesTableCreateCompanionBuilder,
    $$EventTypesTableUpdateCompanionBuilder,
    (EventType, $$EventTypesTableReferences),
    EventType,
    PrefetchHooks Function({bool eventsRefs, bool remindersRefs})>;
typedef $$ImagesTableCreateCompanionBuilder = ImagesCompanion Function({
  Value<int> id,
  required String base64,
  Value<String?> description,
  Value<DateTime?> createdAt,
});
typedef $$ImagesTableUpdateCompanionBuilder = ImagesCompanion Function({
  Value<int> id,
  Value<String> base64,
  Value<String?> description,
  Value<DateTime?> createdAt,
});

final class $$ImagesTableReferences
    extends BaseReferences<_$AppDatabase, $ImagesTable, Image> {
  $$ImagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SpeciesTable, List<Specy>> _speciesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.species,
          aliasName: $_aliasNameGenerator(db.images.id, db.species.avatar));

  $$SpeciesTableProcessedTableManager get speciesRefs {
    final manager = $$SpeciesTableTableManager($_db, $_db.species)
        .filter((f) => f.avatar.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_speciesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PlantsTable, List<Plant>> _plantsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.plants,
          aliasName: $_aliasNameGenerator(db.images.id, db.plants.avatar));

  $$PlantsTableProcessedTableManager get plantsRefs {
    final manager = $$PlantsTableTableManager($_db, $_db.plants)
        .filter((f) => f.avatar.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_plantsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ImagesTableFilterComposer
    extends Composer<_$AppDatabase, $ImagesTable> {
  $$ImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get base64 => $composableBuilder(
      column: $table.base64, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> speciesRefs(
      Expression<bool> Function($$SpeciesTableFilterComposer f) f) {
    final $$SpeciesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.species,
        getReferencedColumn: (t) => t.avatar,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeciesTableFilterComposer(
              $db: $db,
              $table: $db.species,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> plantsRefs(
      Expression<bool> Function($$PlantsTableFilterComposer f) f) {
    final $$PlantsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.avatar,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableFilterComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ImagesTable> {
  $$ImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get base64 => $composableBuilder(
      column: $table.base64, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImagesTable> {
  $$ImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get base64 =>
      $composableBuilder(column: $table.base64, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> speciesRefs<T extends Object>(
      Expression<T> Function($$SpeciesTableAnnotationComposer a) f) {
    final $$SpeciesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.species,
        getReferencedColumn: (t) => t.avatar,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeciesTableAnnotationComposer(
              $db: $db,
              $table: $db.species,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> plantsRefs<T extends Object>(
      Expression<T> Function($$PlantsTableAnnotationComposer a) f) {
    final $$PlantsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.avatar,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableAnnotationComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ImagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ImagesTable,
    Image,
    $$ImagesTableFilterComposer,
    $$ImagesTableOrderingComposer,
    $$ImagesTableAnnotationComposer,
    $$ImagesTableCreateCompanionBuilder,
    $$ImagesTableUpdateCompanionBuilder,
    (Image, $$ImagesTableReferences),
    Image,
    PrefetchHooks Function({bool speciesRefs, bool plantsRefs})> {
  $$ImagesTableTableManager(_$AppDatabase db, $ImagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> base64 = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              ImagesCompanion(
            id: id,
            base64: base64,
            description: description,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String base64,
            Value<String?> description = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              ImagesCompanion.insert(
            id: id,
            base64: base64,
            description: description,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ImagesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({speciesRefs = false, plantsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (speciesRefs) db.species,
                if (plantsRefs) db.plants
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (speciesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$ImagesTableReferences._speciesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ImagesTableReferences(db, table, p0).speciesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.avatar == item.id),
                        typedResults: items),
                  if (plantsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$ImagesTableReferences._plantsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ImagesTableReferences(db, table, p0).plantsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.avatar == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ImagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ImagesTable,
    Image,
    $$ImagesTableFilterComposer,
    $$ImagesTableOrderingComposer,
    $$ImagesTableAnnotationComposer,
    $$ImagesTableCreateCompanionBuilder,
    $$ImagesTableUpdateCompanionBuilder,
    (Image, $$ImagesTableReferences),
    Image,
    PrefetchHooks Function({bool speciesRefs, bool plantsRefs})>;
typedef $$SpeciesTableCreateCompanionBuilder = SpeciesCompanion Function({
  Value<int> id,
  required String scientificName,
  required String family,
  required String genus,
  required String species,
  Value<String?> author,
  Value<int?> avatar,
  Value<String?> avatarUrl,
  Value<SpeciesDataSource> dataSource,
  Value<String?> externalId,
  Value<int?> year,
  Value<String?> bibliography,
});
typedef $$SpeciesTableUpdateCompanionBuilder = SpeciesCompanion Function({
  Value<int> id,
  Value<String> scientificName,
  Value<String> family,
  Value<String> genus,
  Value<String> species,
  Value<String?> author,
  Value<int?> avatar,
  Value<String?> avatarUrl,
  Value<SpeciesDataSource> dataSource,
  Value<String?> externalId,
  Value<int?> year,
  Value<String?> bibliography,
});

final class $$SpeciesTableReferences
    extends BaseReferences<_$AppDatabase, $SpeciesTable, Specy> {
  $$SpeciesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ImagesTable _avatarTable(_$AppDatabase db) => db.images
      .createAlias($_aliasNameGenerator(db.species.avatar, db.images.id));

  $$ImagesTableProcessedTableManager? get avatar {
    if ($_item.avatar == null) return null;
    final manager = $$ImagesTableTableManager($_db, $_db.images)
        .filter((f) => f.id($_item.avatar!));
    final item = $_typedResult.readTableOrNull(_avatarTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PlantsTable, List<Plant>> _plantsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.plants,
          aliasName: $_aliasNameGenerator(db.species.id, db.plants.species));

  $$PlantsTableProcessedTableManager get plantsRefs {
    final manager = $$PlantsTableTableManager($_db, $_db.plants)
        .filter((f) => f.species.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_plantsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SpeciesSynonymsTable, List<SpeciesSynonym>>
      _speciesSynonymsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.speciesSynonyms,
              aliasName: $_aliasNameGenerator(
                  db.species.id, db.speciesSynonyms.species));

  $$SpeciesSynonymsTableProcessedTableManager get speciesSynonymsRefs {
    final manager =
        $$SpeciesSynonymsTableTableManager($_db, $_db.speciesSynonyms)
            .filter((f) => f.species.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_speciesSynonymsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SpeciesCareTable, List<SpeciesCareData>>
      _speciesCareRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.speciesCare,
              aliasName:
                  $_aliasNameGenerator(db.species.id, db.speciesCare.species));

  $$SpeciesCareTableProcessedTableManager get speciesCareRefs {
    final manager = $$SpeciesCareTableTableManager($_db, $_db.speciesCare)
        .filter((f) => f.species.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_speciesCareRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SpeciesTableFilterComposer
    extends Composer<_$AppDatabase, $SpeciesTable> {
  $$SpeciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scientificName => $composableBuilder(
      column: $table.scientificName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get family => $composableBuilder(
      column: $table.family, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get genus => $composableBuilder(
      column: $table.genus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get species => $composableBuilder(
      column: $table.species, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SpeciesDataSource, SpeciesDataSource, String>
      get dataSource => $composableBuilder(
          column: $table.dataSource,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get externalId => $composableBuilder(
      column: $table.externalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bibliography => $composableBuilder(
      column: $table.bibliography, builder: (column) => ColumnFilters(column));

  $$ImagesTableFilterComposer get avatar {
    final $$ImagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.avatar,
        referencedTable: $db.images,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ImagesTableFilterComposer(
              $db: $db,
              $table: $db.images,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> plantsRefs(
      Expression<bool> Function($$PlantsTableFilterComposer f) f) {
    final $$PlantsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.species,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableFilterComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> speciesSynonymsRefs(
      Expression<bool> Function($$SpeciesSynonymsTableFilterComposer f) f) {
    final $$SpeciesSynonymsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.speciesSynonyms,
        getReferencedColumn: (t) => t.species,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeciesSynonymsTableFilterComposer(
              $db: $db,
              $table: $db.speciesSynonyms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> speciesCareRefs(
      Expression<bool> Function($$SpeciesCareTableFilterComposer f) f) {
    final $$SpeciesCareTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.speciesCare,
        getReferencedColumn: (t) => t.species,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeciesCareTableFilterComposer(
              $db: $db,
              $table: $db.speciesCare,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SpeciesTableOrderingComposer
    extends Composer<_$AppDatabase, $SpeciesTable> {
  $$SpeciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scientificName => $composableBuilder(
      column: $table.scientificName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get family => $composableBuilder(
      column: $table.family, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get genus => $composableBuilder(
      column: $table.genus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get species => $composableBuilder(
      column: $table.species, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dataSource => $composableBuilder(
      column: $table.dataSource, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get externalId => $composableBuilder(
      column: $table.externalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bibliography => $composableBuilder(
      column: $table.bibliography,
      builder: (column) => ColumnOrderings(column));

  $$ImagesTableOrderingComposer get avatar {
    final $$ImagesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.avatar,
        referencedTable: $db.images,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ImagesTableOrderingComposer(
              $db: $db,
              $table: $db.images,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SpeciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpeciesTable> {
  $$SpeciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scientificName => $composableBuilder(
      column: $table.scientificName, builder: (column) => column);

  GeneratedColumn<String> get family =>
      $composableBuilder(column: $table.family, builder: (column) => column);

  GeneratedColumn<String> get genus =>
      $composableBuilder(column: $table.genus, builder: (column) => column);

  GeneratedColumn<String> get species =>
      $composableBuilder(column: $table.species, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SpeciesDataSource, String> get dataSource =>
      $composableBuilder(
          column: $table.dataSource, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
      column: $table.externalId, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get bibliography => $composableBuilder(
      column: $table.bibliography, builder: (column) => column);

  $$ImagesTableAnnotationComposer get avatar {
    final $$ImagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.avatar,
        referencedTable: $db.images,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ImagesTableAnnotationComposer(
              $db: $db,
              $table: $db.images,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> plantsRefs<T extends Object>(
      Expression<T> Function($$PlantsTableAnnotationComposer a) f) {
    final $$PlantsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.species,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableAnnotationComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> speciesSynonymsRefs<T extends Object>(
      Expression<T> Function($$SpeciesSynonymsTableAnnotationComposer a) f) {
    final $$SpeciesSynonymsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.speciesSynonyms,
        getReferencedColumn: (t) => t.species,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeciesSynonymsTableAnnotationComposer(
              $db: $db,
              $table: $db.speciesSynonyms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> speciesCareRefs<T extends Object>(
      Expression<T> Function($$SpeciesCareTableAnnotationComposer a) f) {
    final $$SpeciesCareTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.speciesCare,
        getReferencedColumn: (t) => t.species,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeciesCareTableAnnotationComposer(
              $db: $db,
              $table: $db.speciesCare,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SpeciesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SpeciesTable,
    Specy,
    $$SpeciesTableFilterComposer,
    $$SpeciesTableOrderingComposer,
    $$SpeciesTableAnnotationComposer,
    $$SpeciesTableCreateCompanionBuilder,
    $$SpeciesTableUpdateCompanionBuilder,
    (Specy, $$SpeciesTableReferences),
    Specy,
    PrefetchHooks Function(
        {bool avatar,
        bool plantsRefs,
        bool speciesSynonymsRefs,
        bool speciesCareRefs})> {
  $$SpeciesTableTableManager(_$AppDatabase db, $SpeciesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpeciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpeciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpeciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> scientificName = const Value.absent(),
            Value<String> family = const Value.absent(),
            Value<String> genus = const Value.absent(),
            Value<String> species = const Value.absent(),
            Value<String?> author = const Value.absent(),
            Value<int?> avatar = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<SpeciesDataSource> dataSource = const Value.absent(),
            Value<String?> externalId = const Value.absent(),
            Value<int?> year = const Value.absent(),
            Value<String?> bibliography = const Value.absent(),
          }) =>
              SpeciesCompanion(
            id: id,
            scientificName: scientificName,
            family: family,
            genus: genus,
            species: species,
            author: author,
            avatar: avatar,
            avatarUrl: avatarUrl,
            dataSource: dataSource,
            externalId: externalId,
            year: year,
            bibliography: bibliography,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String scientificName,
            required String family,
            required String genus,
            required String species,
            Value<String?> author = const Value.absent(),
            Value<int?> avatar = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<SpeciesDataSource> dataSource = const Value.absent(),
            Value<String?> externalId = const Value.absent(),
            Value<int?> year = const Value.absent(),
            Value<String?> bibliography = const Value.absent(),
          }) =>
              SpeciesCompanion.insert(
            id: id,
            scientificName: scientificName,
            family: family,
            genus: genus,
            species: species,
            author: author,
            avatar: avatar,
            avatarUrl: avatarUrl,
            dataSource: dataSource,
            externalId: externalId,
            year: year,
            bibliography: bibliography,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SpeciesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {avatar = false,
              plantsRefs = false,
              speciesSynonymsRefs = false,
              speciesCareRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (plantsRefs) db.plants,
                if (speciesSynonymsRefs) db.speciesSynonyms,
                if (speciesCareRefs) db.speciesCare
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (avatar) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.avatar,
                    referencedTable: $$SpeciesTableReferences._avatarTable(db),
                    referencedColumn:
                        $$SpeciesTableReferences._avatarTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (plantsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$SpeciesTableReferences._plantsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SpeciesTableReferences(db, table, p0).plantsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.species == item.id),
                        typedResults: items),
                  if (speciesSynonymsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$SpeciesTableReferences
                            ._speciesSynonymsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SpeciesTableReferences(db, table, p0)
                                .speciesSynonymsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.species == item.id),
                        typedResults: items),
                  if (speciesCareRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$SpeciesTableReferences._speciesCareRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SpeciesTableReferences(db, table, p0)
                                .speciesCareRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.species == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SpeciesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SpeciesTable,
    Specy,
    $$SpeciesTableFilterComposer,
    $$SpeciesTableOrderingComposer,
    $$SpeciesTableAnnotationComposer,
    $$SpeciesTableCreateCompanionBuilder,
    $$SpeciesTableUpdateCompanionBuilder,
    (Specy, $$SpeciesTableReferences),
    Specy,
    PrefetchHooks Function(
        {bool avatar,
        bool plantsRefs,
        bool speciesSynonymsRefs,
        bool speciesCareRefs})>;
typedef $$PlantsTableCreateCompanionBuilder = PlantsCompanion Function({
  Value<int> id,
  required String name,
  Value<DateTime?> startDate,
  Value<String?> note,
  Value<DateTime?> createdAt,
  required int species,
  Value<int?> avatar,
  Value<AvatarMode> avatarMode,
});
typedef $$PlantsTableUpdateCompanionBuilder = PlantsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime?> startDate,
  Value<String?> note,
  Value<DateTime?> createdAt,
  Value<int> species,
  Value<int?> avatar,
  Value<AvatarMode> avatarMode,
});

final class $$PlantsTableReferences
    extends BaseReferences<_$AppDatabase, $PlantsTable, Plant> {
  $$PlantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SpeciesTable _speciesTable(_$AppDatabase db) => db.species
      .createAlias($_aliasNameGenerator(db.plants.species, db.species.id));

  $$SpeciesTableProcessedTableManager get species {
    final manager = $$SpeciesTableTableManager($_db, $_db.species)
        .filter((f) => f.id($_item.species));
    final item = $_typedResult.readTableOrNull(_speciesTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ImagesTable _avatarTable(_$AppDatabase db) => db.images
      .createAlias($_aliasNameGenerator(db.plants.avatar, db.images.id));

  $$ImagesTableProcessedTableManager? get avatar {
    if ($_item.avatar == null) return null;
    final manager = $$ImagesTableTableManager($_db, $_db.images)
        .filter((f) => f.id($_item.avatar!));
    final item = $_typedResult.readTableOrNull(_avatarTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$EventsTable, List<Event>> _eventsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.events,
          aliasName: $_aliasNameGenerator(db.plants.id, db.events.plant));

  $$EventsTableProcessedTableManager get eventsRefs {
    final manager = $$EventsTableTableManager($_db, $_db.events)
        .filter((f) => f.plant.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_eventsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RemindersTable, List<Reminder>>
      _remindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.reminders,
          aliasName: $_aliasNameGenerator(db.plants.id, db.reminders.plant));

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager($_db, $_db.reminders)
        .filter((f) => f.plant.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PlantsTableFilterComposer
    extends Composer<_$AppDatabase, $PlantsTable> {
  $$PlantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AvatarMode, AvatarMode, String>
      get avatarMode => $composableBuilder(
          column: $table.avatarMode,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$SpeciesTableFilterComposer get species {
    final $$SpeciesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.species,
        referencedTable: $db.species,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeciesTableFilterComposer(
              $db: $db,
              $table: $db.species,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ImagesTableFilterComposer get avatar {
    final $$ImagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.avatar,
        referencedTable: $db.images,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ImagesTableFilterComposer(
              $db: $db,
              $table: $db.images,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> eventsRefs(
      Expression<bool> Function($$EventsTableFilterComposer f) f) {
    final $$EventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.plant,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableFilterComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> remindersRefs(
      Expression<bool> Function($$RemindersTableFilterComposer f) f) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reminders,
        getReferencedColumn: (t) => t.plant,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableFilterComposer(
              $db: $db,
              $table: $db.reminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PlantsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlantsTable> {
  $$PlantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarMode => $composableBuilder(
      column: $table.avatarMode, builder: (column) => ColumnOrderings(column));

  $$SpeciesTableOrderingComposer get species {
    final $$SpeciesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.species,
        referencedTable: $db.species,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeciesTableOrderingComposer(
              $db: $db,
              $table: $db.species,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ImagesTableOrderingComposer get avatar {
    final $$ImagesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.avatar,
        referencedTable: $db.images,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ImagesTableOrderingComposer(
              $db: $db,
              $table: $db.images,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlantsTable> {
  $$PlantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AvatarMode, String> get avatarMode =>
      $composableBuilder(
          column: $table.avatarMode, builder: (column) => column);

  $$SpeciesTableAnnotationComposer get species {
    final $$SpeciesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.species,
        referencedTable: $db.species,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeciesTableAnnotationComposer(
              $db: $db,
              $table: $db.species,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ImagesTableAnnotationComposer get avatar {
    final $$ImagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.avatar,
        referencedTable: $db.images,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ImagesTableAnnotationComposer(
              $db: $db,
              $table: $db.images,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> eventsRefs<T extends Object>(
      Expression<T> Function($$EventsTableAnnotationComposer a) f) {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.plant,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableAnnotationComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> remindersRefs<T extends Object>(
      Expression<T> Function($$RemindersTableAnnotationComposer a) f) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reminders,
        getReferencedColumn: (t) => t.plant,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableAnnotationComposer(
              $db: $db,
              $table: $db.reminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PlantsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlantsTable,
    Plant,
    $$PlantsTableFilterComposer,
    $$PlantsTableOrderingComposer,
    $$PlantsTableAnnotationComposer,
    $$PlantsTableCreateCompanionBuilder,
    $$PlantsTableUpdateCompanionBuilder,
    (Plant, $$PlantsTableReferences),
    Plant,
    PrefetchHooks Function(
        {bool species, bool avatar, bool eventsRefs, bool remindersRefs})> {
  $$PlantsTableTableManager(_$AppDatabase db, $PlantsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<int> species = const Value.absent(),
            Value<int?> avatar = const Value.absent(),
            Value<AvatarMode> avatarMode = const Value.absent(),
          }) =>
              PlantsCompanion(
            id: id,
            name: name,
            startDate: startDate,
            note: note,
            createdAt: createdAt,
            species: species,
            avatar: avatar,
            avatarMode: avatarMode,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<DateTime?> startDate = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            required int species,
            Value<int?> avatar = const Value.absent(),
            Value<AvatarMode> avatarMode = const Value.absent(),
          }) =>
              PlantsCompanion.insert(
            id: id,
            name: name,
            startDate: startDate,
            note: note,
            createdAt: createdAt,
            species: species,
            avatar: avatar,
            avatarMode: avatarMode,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PlantsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {species = false,
              avatar = false,
              eventsRefs = false,
              remindersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (eventsRefs) db.events,
                if (remindersRefs) db.reminders
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (species) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.species,
                    referencedTable: $$PlantsTableReferences._speciesTable(db),
                    referencedColumn:
                        $$PlantsTableReferences._speciesTable(db).id,
                  ) as T;
                }
                if (avatar) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.avatar,
                    referencedTable: $$PlantsTableReferences._avatarTable(db),
                    referencedColumn:
                        $$PlantsTableReferences._avatarTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (eventsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$PlantsTableReferences._eventsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlantsTableReferences(db, table, p0).eventsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.plant == item.id),
                        typedResults: items),
                  if (remindersRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$PlantsTableReferences._remindersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlantsTableReferences(db, table, p0)
                                .remindersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.plant == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PlantsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlantsTable,
    Plant,
    $$PlantsTableFilterComposer,
    $$PlantsTableOrderingComposer,
    $$PlantsTableAnnotationComposer,
    $$PlantsTableCreateCompanionBuilder,
    $$PlantsTableUpdateCompanionBuilder,
    (Plant, $$PlantsTableReferences),
    Plant,
    PrefetchHooks Function(
        {bool species, bool avatar, bool eventsRefs, bool remindersRefs})>;
typedef $$SpeciesSynonymsTableCreateCompanionBuilder = SpeciesSynonymsCompanion
    Function({
  Value<int> id,
  required int species,
  required String synonym,
});
typedef $$SpeciesSynonymsTableUpdateCompanionBuilder = SpeciesSynonymsCompanion
    Function({
  Value<int> id,
  Value<int> species,
  Value<String> synonym,
});

final class $$SpeciesSynonymsTableReferences extends BaseReferences<
    _$AppDatabase, $SpeciesSynonymsTable, SpeciesSynonym> {
  $$SpeciesSynonymsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SpeciesTable _speciesTable(_$AppDatabase db) =>
      db.species.createAlias(
          $_aliasNameGenerator(db.speciesSynonyms.species, db.species.id));

  $$SpeciesTableProcessedTableManager get species {
    final manager = $$SpeciesTableTableManager($_db, $_db.species)
        .filter((f) => f.id($_item.species));
    final item = $_typedResult.readTableOrNull(_speciesTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SpeciesSynonymsTableFilterComposer
    extends Composer<_$AppDatabase, $SpeciesSynonymsTable> {
  $$SpeciesSynonymsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get synonym => $composableBuilder(
      column: $table.synonym, builder: (column) => ColumnFilters(column));

  $$SpeciesTableFilterComposer get species {
    final $$SpeciesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.species,
        referencedTable: $db.species,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeciesTableFilterComposer(
              $db: $db,
              $table: $db.species,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SpeciesSynonymsTableOrderingComposer
    extends Composer<_$AppDatabase, $SpeciesSynonymsTable> {
  $$SpeciesSynonymsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get synonym => $composableBuilder(
      column: $table.synonym, builder: (column) => ColumnOrderings(column));

  $$SpeciesTableOrderingComposer get species {
    final $$SpeciesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.species,
        referencedTable: $db.species,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeciesTableOrderingComposer(
              $db: $db,
              $table: $db.species,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SpeciesSynonymsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpeciesSynonymsTable> {
  $$SpeciesSynonymsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get synonym =>
      $composableBuilder(column: $table.synonym, builder: (column) => column);

  $$SpeciesTableAnnotationComposer get species {
    final $$SpeciesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.species,
        referencedTable: $db.species,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeciesTableAnnotationComposer(
              $db: $db,
              $table: $db.species,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SpeciesSynonymsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SpeciesSynonymsTable,
    SpeciesSynonym,
    $$SpeciesSynonymsTableFilterComposer,
    $$SpeciesSynonymsTableOrderingComposer,
    $$SpeciesSynonymsTableAnnotationComposer,
    $$SpeciesSynonymsTableCreateCompanionBuilder,
    $$SpeciesSynonymsTableUpdateCompanionBuilder,
    (SpeciesSynonym, $$SpeciesSynonymsTableReferences),
    SpeciesSynonym,
    PrefetchHooks Function({bool species})> {
  $$SpeciesSynonymsTableTableManager(
      _$AppDatabase db, $SpeciesSynonymsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpeciesSynonymsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpeciesSynonymsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpeciesSynonymsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> species = const Value.absent(),
            Value<String> synonym = const Value.absent(),
          }) =>
              SpeciesSynonymsCompanion(
            id: id,
            species: species,
            synonym: synonym,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int species,
            required String synonym,
          }) =>
              SpeciesSynonymsCompanion.insert(
            id: id,
            species: species,
            synonym: synonym,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SpeciesSynonymsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({species = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (species) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.species,
                    referencedTable:
                        $$SpeciesSynonymsTableReferences._speciesTable(db),
                    referencedColumn:
                        $$SpeciesSynonymsTableReferences._speciesTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SpeciesSynonymsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SpeciesSynonymsTable,
    SpeciesSynonym,
    $$SpeciesSynonymsTableFilterComposer,
    $$SpeciesSynonymsTableOrderingComposer,
    $$SpeciesSynonymsTableAnnotationComposer,
    $$SpeciesSynonymsTableCreateCompanionBuilder,
    $$SpeciesSynonymsTableUpdateCompanionBuilder,
    (SpeciesSynonym, $$SpeciesSynonymsTableReferences),
    SpeciesSynonym,
    PrefetchHooks Function({bool species})>;
typedef $$SpeciesCareTableCreateCompanionBuilder = SpeciesCareCompanion
    Function({
  Value<int> species,
  Value<int?> light,
  Value<int?> humidity,
  Value<int?> tempMax,
  Value<int?> tempMin,
  Value<int?> phMin,
  Value<int?> phMax,
});
typedef $$SpeciesCareTableUpdateCompanionBuilder = SpeciesCareCompanion
    Function({
  Value<int> species,
  Value<int?> light,
  Value<int?> humidity,
  Value<int?> tempMax,
  Value<int?> tempMin,
  Value<int?> phMin,
  Value<int?> phMax,
});

final class $$SpeciesCareTableReferences
    extends BaseReferences<_$AppDatabase, $SpeciesCareTable, SpeciesCareData> {
  $$SpeciesCareTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SpeciesTable _speciesTable(_$AppDatabase db) => db.species
      .createAlias($_aliasNameGenerator(db.speciesCare.species, db.species.id));

  $$SpeciesTableProcessedTableManager get species {
    final manager = $$SpeciesTableTableManager($_db, $_db.species)
        .filter((f) => f.id($_item.species));
    final item = $_typedResult.readTableOrNull(_speciesTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SpeciesCareTableFilterComposer
    extends Composer<_$AppDatabase, $SpeciesCareTable> {
  $$SpeciesCareTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get light => $composableBuilder(
      column: $table.light, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get humidity => $composableBuilder(
      column: $table.humidity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tempMax => $composableBuilder(
      column: $table.tempMax, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tempMin => $composableBuilder(
      column: $table.tempMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get phMin => $composableBuilder(
      column: $table.phMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get phMax => $composableBuilder(
      column: $table.phMax, builder: (column) => ColumnFilters(column));

  $$SpeciesTableFilterComposer get species {
    final $$SpeciesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.species,
        referencedTable: $db.species,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeciesTableFilterComposer(
              $db: $db,
              $table: $db.species,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SpeciesCareTableOrderingComposer
    extends Composer<_$AppDatabase, $SpeciesCareTable> {
  $$SpeciesCareTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get light => $composableBuilder(
      column: $table.light, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get humidity => $composableBuilder(
      column: $table.humidity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tempMax => $composableBuilder(
      column: $table.tempMax, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tempMin => $composableBuilder(
      column: $table.tempMin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get phMin => $composableBuilder(
      column: $table.phMin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get phMax => $composableBuilder(
      column: $table.phMax, builder: (column) => ColumnOrderings(column));

  $$SpeciesTableOrderingComposer get species {
    final $$SpeciesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.species,
        referencedTable: $db.species,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeciesTableOrderingComposer(
              $db: $db,
              $table: $db.species,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SpeciesCareTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpeciesCareTable> {
  $$SpeciesCareTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get light =>
      $composableBuilder(column: $table.light, builder: (column) => column);

  GeneratedColumn<int> get humidity =>
      $composableBuilder(column: $table.humidity, builder: (column) => column);

  GeneratedColumn<int> get tempMax =>
      $composableBuilder(column: $table.tempMax, builder: (column) => column);

  GeneratedColumn<int> get tempMin =>
      $composableBuilder(column: $table.tempMin, builder: (column) => column);

  GeneratedColumn<int> get phMin =>
      $composableBuilder(column: $table.phMin, builder: (column) => column);

  GeneratedColumn<int> get phMax =>
      $composableBuilder(column: $table.phMax, builder: (column) => column);

  $$SpeciesTableAnnotationComposer get species {
    final $$SpeciesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.species,
        referencedTable: $db.species,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeciesTableAnnotationComposer(
              $db: $db,
              $table: $db.species,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SpeciesCareTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SpeciesCareTable,
    SpeciesCareData,
    $$SpeciesCareTableFilterComposer,
    $$SpeciesCareTableOrderingComposer,
    $$SpeciesCareTableAnnotationComposer,
    $$SpeciesCareTableCreateCompanionBuilder,
    $$SpeciesCareTableUpdateCompanionBuilder,
    (SpeciesCareData, $$SpeciesCareTableReferences),
    SpeciesCareData,
    PrefetchHooks Function({bool species})> {
  $$SpeciesCareTableTableManager(_$AppDatabase db, $SpeciesCareTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpeciesCareTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpeciesCareTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpeciesCareTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> species = const Value.absent(),
            Value<int?> light = const Value.absent(),
            Value<int?> humidity = const Value.absent(),
            Value<int?> tempMax = const Value.absent(),
            Value<int?> tempMin = const Value.absent(),
            Value<int?> phMin = const Value.absent(),
            Value<int?> phMax = const Value.absent(),
          }) =>
              SpeciesCareCompanion(
            species: species,
            light: light,
            humidity: humidity,
            tempMax: tempMax,
            tempMin: tempMin,
            phMin: phMin,
            phMax: phMax,
          ),
          createCompanionCallback: ({
            Value<int> species = const Value.absent(),
            Value<int?> light = const Value.absent(),
            Value<int?> humidity = const Value.absent(),
            Value<int?> tempMax = const Value.absent(),
            Value<int?> tempMin = const Value.absent(),
            Value<int?> phMin = const Value.absent(),
            Value<int?> phMax = const Value.absent(),
          }) =>
              SpeciesCareCompanion.insert(
            species: species,
            light: light,
            humidity: humidity,
            tempMax: tempMax,
            tempMin: tempMin,
            phMin: phMin,
            phMax: phMax,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SpeciesCareTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({species = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (species) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.species,
                    referencedTable:
                        $$SpeciesCareTableReferences._speciesTable(db),
                    referencedColumn:
                        $$SpeciesCareTableReferences._speciesTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SpeciesCareTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SpeciesCareTable,
    SpeciesCareData,
    $$SpeciesCareTableFilterComposer,
    $$SpeciesCareTableOrderingComposer,
    $$SpeciesCareTableAnnotationComposer,
    $$SpeciesCareTableCreateCompanionBuilder,
    $$SpeciesCareTableUpdateCompanionBuilder,
    (SpeciesCareData, $$SpeciesCareTableReferences),
    SpeciesCareData,
    PrefetchHooks Function({bool species})>;
typedef $$EventsTableCreateCompanionBuilder = EventsCompanion Function({
  Value<int> id,
  required int type,
  required int plant,
  Value<String?> note,
  required DateTime date,
});
typedef $$EventsTableUpdateCompanionBuilder = EventsCompanion Function({
  Value<int> id,
  Value<int> type,
  Value<int> plant,
  Value<String?> note,
  Value<DateTime> date,
});

final class $$EventsTableReferences
    extends BaseReferences<_$AppDatabase, $EventsTable, Event> {
  $$EventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventTypesTable _typeTable(_$AppDatabase db) => db.eventTypes
      .createAlias($_aliasNameGenerator(db.events.type, db.eventTypes.id));

  $$EventTypesTableProcessedTableManager get type {
    final manager = $$EventTypesTableTableManager($_db, $_db.eventTypes)
        .filter((f) => f.id($_item.type));
    final item = $_typedResult.readTableOrNull(_typeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PlantsTable _plantTable(_$AppDatabase db) => db.plants
      .createAlias($_aliasNameGenerator(db.events.plant, db.plants.id));

  $$PlantsTableProcessedTableManager get plant {
    final manager = $$PlantsTableTableManager($_db, $_db.plants)
        .filter((f) => f.id($_item.plant));
    final item = $_typedResult.readTableOrNull(_plantTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  $$EventTypesTableFilterComposer get type {
    final $$EventTypesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.type,
        referencedTable: $db.eventTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventTypesTableFilterComposer(
              $db: $db,
              $table: $db.eventTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlantsTableFilterComposer get plant {
    final $$PlantsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.plant,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableFilterComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  $$EventTypesTableOrderingComposer get type {
    final $$EventTypesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.type,
        referencedTable: $db.eventTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventTypesTableOrderingComposer(
              $db: $db,
              $table: $db.eventTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlantsTableOrderingComposer get plant {
    final $$PlantsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.plant,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableOrderingComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  $$EventTypesTableAnnotationComposer get type {
    final $$EventTypesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.type,
        referencedTable: $db.eventTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventTypesTableAnnotationComposer(
              $db: $db,
              $table: $db.eventTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlantsTableAnnotationComposer get plant {
    final $$PlantsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.plant,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableAnnotationComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EventsTable,
    Event,
    $$EventsTableFilterComposer,
    $$EventsTableOrderingComposer,
    $$EventsTableAnnotationComposer,
    $$EventsTableCreateCompanionBuilder,
    $$EventsTableUpdateCompanionBuilder,
    (Event, $$EventsTableReferences),
    Event,
    PrefetchHooks Function({bool type, bool plant})> {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> type = const Value.absent(),
            Value<int> plant = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
          }) =>
              EventsCompanion(
            id: id,
            type: type,
            plant: plant,
            note: note,
            date: date,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int type,
            required int plant,
            Value<String?> note = const Value.absent(),
            required DateTime date,
          }) =>
              EventsCompanion.insert(
            id: id,
            type: type,
            plant: plant,
            note: note,
            date: date,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$EventsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({type = false, plant = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (type) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.type,
                    referencedTable: $$EventsTableReferences._typeTable(db),
                    referencedColumn: $$EventsTableReferences._typeTable(db).id,
                  ) as T;
                }
                if (plant) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.plant,
                    referencedTable: $$EventsTableReferences._plantTable(db),
                    referencedColumn:
                        $$EventsTableReferences._plantTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EventsTable,
    Event,
    $$EventsTableFilterComposer,
    $$EventsTableOrderingComposer,
    $$EventsTableAnnotationComposer,
    $$EventsTableCreateCompanionBuilder,
    $$EventsTableUpdateCompanionBuilder,
    (Event, $$EventsTableReferences),
    Event,
    PrefetchHooks Function({bool type, bool plant})>;
typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  required int type,
  required int plant,
  required DateTime startDate,
  Value<DateTime?> endDate,
  required FrequencyUnit frequencyUnit,
  required int frequencyQuantity,
  required FrequencyUnit repeatAfterUnit,
  required int repeatAfterQuantity,
  Value<DateTime?> lastNotified,
  required bool enabled,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  Value<int> type,
  Value<int> plant,
  Value<DateTime> startDate,
  Value<DateTime?> endDate,
  Value<FrequencyUnit> frequencyUnit,
  Value<int> frequencyQuantity,
  Value<FrequencyUnit> repeatAfterUnit,
  Value<int> repeatAfterQuantity,
  Value<DateTime?> lastNotified,
  Value<bool> enabled,
});

final class $$RemindersTableReferences
    extends BaseReferences<_$AppDatabase, $RemindersTable, Reminder> {
  $$RemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventTypesTable _typeTable(_$AppDatabase db) => db.eventTypes
      .createAlias($_aliasNameGenerator(db.reminders.type, db.eventTypes.id));

  $$EventTypesTableProcessedTableManager get type {
    final manager = $$EventTypesTableTableManager($_db, $_db.eventTypes)
        .filter((f) => f.id($_item.type));
    final item = $_typedResult.readTableOrNull(_typeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PlantsTable _plantTable(_$AppDatabase db) => db.plants
      .createAlias($_aliasNameGenerator(db.reminders.plant, db.plants.id));

  $$PlantsTableProcessedTableManager get plant {
    final manager = $$PlantsTableTableManager($_db, $_db.plants)
        .filter((f) => f.id($_item.plant));
    final item = $_typedResult.readTableOrNull(_plantTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<FrequencyUnit, FrequencyUnit, String>
      get frequencyUnit => $composableBuilder(
          column: $table.frequencyUnit,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get frequencyQuantity => $composableBuilder(
      column: $table.frequencyQuantity,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<FrequencyUnit, FrequencyUnit, String>
      get repeatAfterUnit => $composableBuilder(
          column: $table.repeatAfterUnit,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get repeatAfterQuantity => $composableBuilder(
      column: $table.repeatAfterQuantity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastNotified => $composableBuilder(
      column: $table.lastNotified, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  $$EventTypesTableFilterComposer get type {
    final $$EventTypesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.type,
        referencedTable: $db.eventTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventTypesTableFilterComposer(
              $db: $db,
              $table: $db.eventTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlantsTableFilterComposer get plant {
    final $$PlantsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.plant,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableFilterComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequencyUnit => $composableBuilder(
      column: $table.frequencyUnit,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get frequencyQuantity => $composableBuilder(
      column: $table.frequencyQuantity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get repeatAfterUnit => $composableBuilder(
      column: $table.repeatAfterUnit,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get repeatAfterQuantity => $composableBuilder(
      column: $table.repeatAfterQuantity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastNotified => $composableBuilder(
      column: $table.lastNotified,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  $$EventTypesTableOrderingComposer get type {
    final $$EventTypesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.type,
        referencedTable: $db.eventTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventTypesTableOrderingComposer(
              $db: $db,
              $table: $db.eventTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlantsTableOrderingComposer get plant {
    final $$PlantsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.plant,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableOrderingComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FrequencyUnit, String> get frequencyUnit =>
      $composableBuilder(
          column: $table.frequencyUnit, builder: (column) => column);

  GeneratedColumn<int> get frequencyQuantity => $composableBuilder(
      column: $table.frequencyQuantity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FrequencyUnit, String> get repeatAfterUnit =>
      $composableBuilder(
          column: $table.repeatAfterUnit, builder: (column) => column);

  GeneratedColumn<int> get repeatAfterQuantity => $composableBuilder(
      column: $table.repeatAfterQuantity, builder: (column) => column);

  GeneratedColumn<DateTime> get lastNotified => $composableBuilder(
      column: $table.lastNotified, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  $$EventTypesTableAnnotationComposer get type {
    final $$EventTypesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.type,
        referencedTable: $db.eventTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventTypesTableAnnotationComposer(
              $db: $db,
              $table: $db.eventTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlantsTableAnnotationComposer get plant {
    final $$PlantsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.plant,
        referencedTable: $db.plants,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlantsTableAnnotationComposer(
              $db: $db,
              $table: $db.plants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RemindersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, $$RemindersTableReferences),
    Reminder,
    PrefetchHooks Function({bool type, bool plant})> {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> type = const Value.absent(),
            Value<int> plant = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<FrequencyUnit> frequencyUnit = const Value.absent(),
            Value<int> frequencyQuantity = const Value.absent(),
            Value<FrequencyUnit> repeatAfterUnit = const Value.absent(),
            Value<int> repeatAfterQuantity = const Value.absent(),
            Value<DateTime?> lastNotified = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
          }) =>
              RemindersCompanion(
            id: id,
            type: type,
            plant: plant,
            startDate: startDate,
            endDate: endDate,
            frequencyUnit: frequencyUnit,
            frequencyQuantity: frequencyQuantity,
            repeatAfterUnit: repeatAfterUnit,
            repeatAfterQuantity: repeatAfterQuantity,
            lastNotified: lastNotified,
            enabled: enabled,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int type,
            required int plant,
            required DateTime startDate,
            Value<DateTime?> endDate = const Value.absent(),
            required FrequencyUnit frequencyUnit,
            required int frequencyQuantity,
            required FrequencyUnit repeatAfterUnit,
            required int repeatAfterQuantity,
            Value<DateTime?> lastNotified = const Value.absent(),
            required bool enabled,
          }) =>
              RemindersCompanion.insert(
            id: id,
            type: type,
            plant: plant,
            startDate: startDate,
            endDate: endDate,
            frequencyUnit: frequencyUnit,
            frequencyQuantity: frequencyQuantity,
            repeatAfterUnit: repeatAfterUnit,
            repeatAfterQuantity: repeatAfterQuantity,
            lastNotified: lastNotified,
            enabled: enabled,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RemindersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({type = false, plant = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (type) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.type,
                    referencedTable: $$RemindersTableReferences._typeTable(db),
                    referencedColumn:
                        $$RemindersTableReferences._typeTable(db).id,
                  ) as T;
                }
                if (plant) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.plant,
                    referencedTable: $$RemindersTableReferences._plantTable(db),
                    referencedColumn:
                        $$RemindersTableReferences._plantTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RemindersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, $$RemindersTableReferences),
    Reminder,
    PrefetchHooks Function({bool type, bool plant})>;
typedef $$UserSettingsTableCreateCompanionBuilder = UserSettingsCompanion
    Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$UserSettingsTableUpdateCompanionBuilder = UserSettingsCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$UserSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$UserSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$UserSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$UserSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserSettingsTable,
    UserSetting,
    $$UserSettingsTableFilterComposer,
    $$UserSettingsTableOrderingComposer,
    $$UserSettingsTableAnnotationComposer,
    $$UserSettingsTableCreateCompanionBuilder,
    $$UserSettingsTableUpdateCompanionBuilder,
    (
      UserSetting,
      BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>
    ),
    UserSetting,
    PrefetchHooks Function()> {
  $$UserSettingsTableTableManager(_$AppDatabase db, $UserSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserSettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              UserSettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserSettingsTable,
    UserSetting,
    $$UserSettingsTableFilterComposer,
    $$UserSettingsTableOrderingComposer,
    $$UserSettingsTableAnnotationComposer,
    $$UserSettingsTableCreateCompanionBuilder,
    $$UserSettingsTableUpdateCompanionBuilder,
    (
      UserSetting,
      BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>
    ),
    UserSetting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EventTypesTableTableManager get eventTypes =>
      $$EventTypesTableTableManager(_db, _db.eventTypes);
  $$ImagesTableTableManager get images =>
      $$ImagesTableTableManager(_db, _db.images);
  $$SpeciesTableTableManager get species =>
      $$SpeciesTableTableManager(_db, _db.species);
  $$PlantsTableTableManager get plants =>
      $$PlantsTableTableManager(_db, _db.plants);
  $$SpeciesSynonymsTableTableManager get speciesSynonyms =>
      $$SpeciesSynonymsTableTableManager(_db, _db.speciesSynonyms);
  $$SpeciesCareTableTableManager get speciesCare =>
      $$SpeciesCareTableTableManager(_db, _db.speciesCare);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$UserSettingsTableTableManager get userSettings =>
      $$UserSettingsTableTableManager(_db, _db.userSettings);
}
