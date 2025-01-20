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
              defaultValue: Constant("none"))
          .withConverter<AvatarMode>($PlantsTable.$converteravatarMode);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, startDate, note, createdAt, avatar, avatarMode];
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
  final int? avatar;
  final AvatarMode avatarMode;
  const Plant(
      {required this.id,
      required this.name,
      this.startDate,
      this.note,
      this.createdAt,
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
          Value<int?> avatar = const Value.absent(),
          AvatarMode? avatarMode}) =>
      Plant(
        id: id ?? this.id,
        name: name ?? this.name,
        startDate: startDate.present ? startDate.value : this.startDate,
        note: note.present ? note.value : this.note,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
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
          ..write('avatar: $avatar, ')
          ..write('avatarMode: $avatarMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, startDate, note, createdAt, avatar, avatarMode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Plant &&
          other.id == this.id &&
          other.name == this.name &&
          other.startDate == this.startDate &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.avatar == this.avatar &&
          other.avatarMode == this.avatarMode);
}

class PlantsCompanion extends UpdateCompanion<Plant> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime?> startDate;
  final Value<String?> note;
  final Value<DateTime?> createdAt;
  final Value<int?> avatar;
  final Value<AvatarMode> avatarMode;
  const PlantsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.startDate = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.avatar = const Value.absent(),
    this.avatarMode = const Value.absent(),
  });
  PlantsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.startDate = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.avatar = const Value.absent(),
    this.avatarMode = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Plant> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? startDate,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? avatar,
    Expression<String>? avatarMode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (startDate != null) 'start_date': startDate,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
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
      Value<int?>? avatar,
      Value<AvatarMode>? avatarMode}) {
    return PlantsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
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
          ..write('avatar: $avatar, ')
          ..write('avatarMode: $avatarMode')
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EventTypesTable eventTypes = $EventTypesTable(this);
  late final $ImagesTable images = $ImagesTable(this);
  late final $PlantsTable plants = $PlantsTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [eventTypes, images, plants, events, reminders];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('images',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('plants', kind: UpdateKind.update),
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
    PrefetchHooks Function({bool plantsRefs})> {
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
          prefetchHooksCallback: ({plantsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (plantsRefs) db.plants],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
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
    PrefetchHooks Function({bool plantsRefs})>;
typedef $$PlantsTableCreateCompanionBuilder = PlantsCompanion Function({
  Value<int> id,
  required String name,
  Value<DateTime?> startDate,
  Value<String?> note,
  Value<DateTime?> createdAt,
  Value<int?> avatar,
  Value<AvatarMode> avatarMode,
});
typedef $$PlantsTableUpdateCompanionBuilder = PlantsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime?> startDate,
  Value<String?> note,
  Value<DateTime?> createdAt,
  Value<int?> avatar,
  Value<AvatarMode> avatarMode,
});

final class $$PlantsTableReferences
    extends BaseReferences<_$AppDatabase, $PlantsTable, Plant> {
  $$PlantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

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
        {bool avatar, bool eventsRefs, bool remindersRefs})> {
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
            Value<int?> avatar = const Value.absent(),
            Value<AvatarMode> avatarMode = const Value.absent(),
          }) =>
              PlantsCompanion(
            id: id,
            name: name,
            startDate: startDate,
            note: note,
            createdAt: createdAt,
            avatar: avatar,
            avatarMode: avatarMode,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<DateTime?> startDate = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<int?> avatar = const Value.absent(),
            Value<AvatarMode> avatarMode = const Value.absent(),
          }) =>
              PlantsCompanion.insert(
            id: id,
            name: name,
            startDate: startDate,
            note: note,
            createdAt: createdAt,
            avatar: avatar,
            avatarMode: avatarMode,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PlantsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {avatar = false, eventsRefs = false, remindersRefs = false}) {
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
    PrefetchHooks Function({bool avatar, bool eventsRefs, bool remindersRefs})>;
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EventTypesTableTableManager get eventTypes =>
      $$EventTypesTableTableManager(_db, _db.eventTypes);
  $$ImagesTableTableManager get images =>
      $$ImagesTableTableManager(_db, _db.images);
  $$PlantsTableTableManager get plants =>
      $$PlantsTableTableManager(_db, _db.plants);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
}
