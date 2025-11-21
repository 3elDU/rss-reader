// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FeedsTable extends Feeds with TableInfo<$FeedsTable, Feed> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    title,
    url,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feeds';
  @override
  VerificationContext validateIntegrity(
    Insertable<Feed> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Feed map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Feed(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $FeedsTable createAlias(String alias) {
    return $FeedsTable(attachedDatabase, alias);
  }
}

class Feed extends DataClass implements Insertable<Feed> {
  final int id;
  final DateTime createdAt;
  final String title;
  final String url;
  final String? description;
  const Feed({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.url,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['title'] = Variable<String>(title);
    map['url'] = Variable<String>(url);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  FeedsCompanion toCompanion(bool nullToAbsent) {
    return FeedsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      title: Value(title),
      url: Value(url),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory Feed.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Feed(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      title: serializer.fromJson<String>(json['title']),
      url: serializer.fromJson<String>(json['url']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'title': serializer.toJson<String>(title),
      'url': serializer.toJson<String>(url),
      'description': serializer.toJson<String?>(description),
    };
  }

  Feed copyWith({
    int? id,
    DateTime? createdAt,
    String? title,
    String? url,
    Value<String?> description = const Value.absent(),
  }) => Feed(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    title: title ?? this.title,
    url: url ?? this.url,
    description: description.present ? description.value : this.description,
  );
  Feed copyWithCompanion(FeedsCompanion data) {
    return Feed(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      title: data.title.present ? data.title.value : this.title,
      url: data.url.present ? data.url.value : this.url,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Feed(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('title: $title, ')
          ..write('url: $url, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, title, url, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Feed &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.title == this.title &&
          other.url == this.url &&
          other.description == this.description);
}

class FeedsCompanion extends UpdateCompanion<Feed> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<String> title;
  final Value<String> url;
  final Value<String?> description;
  const FeedsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.title = const Value.absent(),
    this.url = const Value.absent(),
    this.description = const Value.absent(),
  });
  FeedsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    required String title,
    required String url,
    this.description = const Value.absent(),
  }) : title = Value(title),
       url = Value(url);
  static Insertable<Feed> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? title,
    Expression<String>? url,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (title != null) 'title': title,
      if (url != null) 'url': url,
      if (description != null) 'description': description,
    });
  }

  FeedsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<String>? title,
    Value<String>? url,
    Value<String?>? description,
  }) {
    return FeedsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      url: url ?? this.url,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('title: $title, ')
          ..write('url: $url, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $ArticlesTable extends Articles with TableInfo<$ArticlesTable, Article> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArticlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _feedMeta = const VerificationMeta('feed');
  @override
  late final GeneratedColumn<int> feed = GeneratedColumn<int>(
    'feed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES feeds (id)',
    ),
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbnailUrlMeta = const VerificationMeta(
    'thumbnailUrl',
  );
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
    'thumbnail_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ArticleStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => ArticleStatus.unread.name,
      ).withConverter<ArticleStatus>($ArticlesTable.$converterstatus);
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    feed,
    url,
    title,
    description,
    thumbnailUrl,
    status,
    publishedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'articles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Article> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('feed')) {
      context.handle(
        _feedMeta,
        feed.isAcceptableOrUnknown(data['feed']!, _feedMeta),
      );
    } else if (isInserting) {
      context.missing(_feedMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
        _thumbnailUrlMeta,
        thumbnailUrl.isAcceptableOrUnknown(
          data['thumbnail_url']!,
          _thumbnailUrlMeta,
        ),
      );
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_publishedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Article map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Article(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      feed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}feed'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      thumbnailUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_url'],
      ),
      status: $ArticlesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      )!,
    );
  }

  @override
  $ArticlesTable createAlias(String alias) {
    return $ArticlesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ArticleStatus, String, String> $converterstatus =
      const EnumNameConverter<ArticleStatus>(ArticleStatus.values);
}

class Article extends DataClass implements Insertable<Article> {
  final int id;
  final DateTime createdAt;
  final int feed;
  final String url;
  final String title;
  final String? description;
  final String? thumbnailUrl;
  final ArticleStatus status;
  final DateTime publishedAt;
  const Article({
    required this.id,
    required this.createdAt,
    required this.feed,
    required this.url,
    required this.title,
    this.description,
    this.thumbnailUrl,
    required this.status,
    required this.publishedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['feed'] = Variable<int>(feed);
    map['url'] = Variable<String>(url);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || thumbnailUrl != null) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    }
    {
      map['status'] = Variable<String>(
        $ArticlesTable.$converterstatus.toSql(status),
      );
    }
    map['published_at'] = Variable<DateTime>(publishedAt);
    return map;
  }

  ArticlesCompanion toCompanion(bool nullToAbsent) {
    return ArticlesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      feed: Value(feed),
      url: Value(url),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      thumbnailUrl: thumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrl),
      status: Value(status),
      publishedAt: Value(publishedAt),
    );
  }

  factory Article.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Article(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      feed: serializer.fromJson<int>(json['feed']),
      url: serializer.fromJson<String>(json['url']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      thumbnailUrl: serializer.fromJson<String?>(json['thumbnailUrl']),
      status: $ArticlesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      publishedAt: serializer.fromJson<DateTime>(json['publishedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'feed': serializer.toJson<int>(feed),
      'url': serializer.toJson<String>(url),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'thumbnailUrl': serializer.toJson<String?>(thumbnailUrl),
      'status': serializer.toJson<String>(
        $ArticlesTable.$converterstatus.toJson(status),
      ),
      'publishedAt': serializer.toJson<DateTime>(publishedAt),
    };
  }

  Article copyWith({
    int? id,
    DateTime? createdAt,
    int? feed,
    String? url,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<String?> thumbnailUrl = const Value.absent(),
    ArticleStatus? status,
    DateTime? publishedAt,
  }) => Article(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    feed: feed ?? this.feed,
    url: url ?? this.url,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    thumbnailUrl: thumbnailUrl.present ? thumbnailUrl.value : this.thumbnailUrl,
    status: status ?? this.status,
    publishedAt: publishedAt ?? this.publishedAt,
  );
  Article copyWithCompanion(ArticlesCompanion data) {
    return Article(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      feed: data.feed.present ? data.feed.value : this.feed,
      url: data.url.present ? data.url.value : this.url,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      status: data.status.present ? data.status.value : this.status,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Article(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('feed: $feed, ')
          ..write('url: $url, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('status: $status, ')
          ..write('publishedAt: $publishedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    feed,
    url,
    title,
    description,
    thumbnailUrl,
    status,
    publishedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Article &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.feed == this.feed &&
          other.url == this.url &&
          other.title == this.title &&
          other.description == this.description &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.status == this.status &&
          other.publishedAt == this.publishedAt);
}

class ArticlesCompanion extends UpdateCompanion<Article> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<int> feed;
  final Value<String> url;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> thumbnailUrl;
  final Value<ArticleStatus> status;
  final Value<DateTime> publishedAt;
  const ArticlesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.feed = const Value.absent(),
    this.url = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.publishedAt = const Value.absent(),
  });
  ArticlesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    required int feed,
    required String url,
    required String title,
    this.description = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime publishedAt,
  }) : feed = Value(feed),
       url = Value(url),
       title = Value(title),
       publishedAt = Value(publishedAt);
  static Insertable<Article> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<int>? feed,
    Expression<String>? url,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? thumbnailUrl,
    Expression<String>? status,
    Expression<DateTime>? publishedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (feed != null) 'feed': feed,
      if (url != null) 'url': url,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (status != null) 'status': status,
      if (publishedAt != null) 'published_at': publishedAt,
    });
  }

  ArticlesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<int>? feed,
    Value<String>? url,
    Value<String>? title,
    Value<String?>? description,
    Value<String?>? thumbnailUrl,
    Value<ArticleStatus>? status,
    Value<DateTime>? publishedAt,
  }) {
    return ArticlesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      feed: feed ?? this.feed,
      url: url ?? this.url,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      status: status ?? this.status,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (feed.present) {
      map['feed'] = Variable<int>(feed.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ArticlesTable.$converterstatus.toSql(status.value),
      );
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArticlesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('feed: $feed, ')
          ..write('url: $url, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('status: $status, ')
          ..write('publishedAt: $publishedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  $DatabaseManager get managers => $DatabaseManager(this);
  late final $FeedsTable feeds = $FeedsTable(this);
  late final $ArticlesTable articles = $ArticlesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [feeds, articles];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$FeedsTableCreateCompanionBuilder =
    FeedsCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      required String title,
      required String url,
      Value<String?> description,
    });
typedef $$FeedsTableUpdateCompanionBuilder =
    FeedsCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<String> title,
      Value<String> url,
      Value<String?> description,
    });

final class $$FeedsTableReferences
    extends BaseReferences<_$Database, $FeedsTable, Feed> {
  $$FeedsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ArticlesTable, List<Article>> _articlesRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.articles,
    aliasName: $_aliasNameGenerator(db.feeds.id, db.articles.feed),
  );

  $$ArticlesTableProcessedTableManager get articlesRefs {
    final manager = $$ArticlesTableTableManager(
      $_db,
      $_db.articles,
    ).filter((f) => f.feed.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_articlesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FeedsTableFilterComposer extends Composer<_$Database, $FeedsTable> {
  $$FeedsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> articlesRefs(
    Expression<bool> Function($$ArticlesTableFilterComposer f) f,
  ) {
    final $$ArticlesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.articles,
      getReferencedColumn: (t) => t.feed,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArticlesTableFilterComposer(
            $db: $db,
            $table: $db.articles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FeedsTableOrderingComposer extends Composer<_$Database, $FeedsTable> {
  $$FeedsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FeedsTableAnnotationComposer extends Composer<_$Database, $FeedsTable> {
  $$FeedsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  Expression<T> articlesRefs<T extends Object>(
    Expression<T> Function($$ArticlesTableAnnotationComposer a) f,
  ) {
    final $$ArticlesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.articles,
      getReferencedColumn: (t) => t.feed,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArticlesTableAnnotationComposer(
            $db: $db,
            $table: $db.articles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FeedsTableTableManager
    extends
        RootTableManager<
          _$Database,
          $FeedsTable,
          Feed,
          $$FeedsTableFilterComposer,
          $$FeedsTableOrderingComposer,
          $$FeedsTableAnnotationComposer,
          $$FeedsTableCreateCompanionBuilder,
          $$FeedsTableUpdateCompanionBuilder,
          (Feed, $$FeedsTableReferences),
          Feed,
          PrefetchHooks Function({bool articlesRefs})
        > {
  $$FeedsTableTableManager(_$Database db, $FeedsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String?> description = const Value.absent(),
              }) => FeedsCompanion(
                id: id,
                createdAt: createdAt,
                title: title,
                url: url,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                required String title,
                required String url,
                Value<String?> description = const Value.absent(),
              }) => FeedsCompanion.insert(
                id: id,
                createdAt: createdAt,
                title: title,
                url: url,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$FeedsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({articlesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (articlesRefs) db.articles],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (articlesRefs)
                    await $_getPrefetchedData<Feed, $FeedsTable, Article>(
                      currentTable: table,
                      referencedTable: $$FeedsTableReferences
                          ._articlesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FeedsTableReferences(db, table, p0).articlesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.feed == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FeedsTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $FeedsTable,
      Feed,
      $$FeedsTableFilterComposer,
      $$FeedsTableOrderingComposer,
      $$FeedsTableAnnotationComposer,
      $$FeedsTableCreateCompanionBuilder,
      $$FeedsTableUpdateCompanionBuilder,
      (Feed, $$FeedsTableReferences),
      Feed,
      PrefetchHooks Function({bool articlesRefs})
    >;
typedef $$ArticlesTableCreateCompanionBuilder =
    ArticlesCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      required int feed,
      required String url,
      required String title,
      Value<String?> description,
      Value<String?> thumbnailUrl,
      Value<ArticleStatus> status,
      required DateTime publishedAt,
    });
typedef $$ArticlesTableUpdateCompanionBuilder =
    ArticlesCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<int> feed,
      Value<String> url,
      Value<String> title,
      Value<String?> description,
      Value<String?> thumbnailUrl,
      Value<ArticleStatus> status,
      Value<DateTime> publishedAt,
    });

final class $$ArticlesTableReferences
    extends BaseReferences<_$Database, $ArticlesTable, Article> {
  $$ArticlesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FeedsTable _feedTable(_$Database db) =>
      db.feeds.createAlias($_aliasNameGenerator(db.articles.feed, db.feeds.id));

  $$FeedsTableProcessedTableManager get feed {
    final $_column = $_itemColumn<int>('feed')!;

    final manager = $$FeedsTableTableManager(
      $_db,
      $_db.feeds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_feedTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ArticlesTableFilterComposer
    extends Composer<_$Database, $ArticlesTable> {
  $$ArticlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ArticleStatus, ArticleStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FeedsTableFilterComposer get feed {
    final $$FeedsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.feed,
      referencedTable: $db.feeds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeedsTableFilterComposer(
            $db: $db,
            $table: $db.feeds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ArticlesTableOrderingComposer
    extends Composer<_$Database, $ArticlesTable> {
  $$ArticlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FeedsTableOrderingComposer get feed {
    final $$FeedsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.feed,
      referencedTable: $db.feeds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeedsTableOrderingComposer(
            $db: $db,
            $table: $db.feeds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ArticlesTableAnnotationComposer
    extends Composer<_$Database, $ArticlesTable> {
  $$ArticlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ArticleStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );

  $$FeedsTableAnnotationComposer get feed {
    final $$FeedsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.feed,
      referencedTable: $db.feeds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeedsTableAnnotationComposer(
            $db: $db,
            $table: $db.feeds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ArticlesTableTableManager
    extends
        RootTableManager<
          _$Database,
          $ArticlesTable,
          Article,
          $$ArticlesTableFilterComposer,
          $$ArticlesTableOrderingComposer,
          $$ArticlesTableAnnotationComposer,
          $$ArticlesTableCreateCompanionBuilder,
          $$ArticlesTableUpdateCompanionBuilder,
          (Article, $$ArticlesTableReferences),
          Article,
          PrefetchHooks Function({bool feed})
        > {
  $$ArticlesTableTableManager(_$Database db, $ArticlesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArticlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArticlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArticlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> feed = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<ArticleStatus> status = const Value.absent(),
                Value<DateTime> publishedAt = const Value.absent(),
              }) => ArticlesCompanion(
                id: id,
                createdAt: createdAt,
                feed: feed,
                url: url,
                title: title,
                description: description,
                thumbnailUrl: thumbnailUrl,
                status: status,
                publishedAt: publishedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                required int feed,
                required String url,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<ArticleStatus> status = const Value.absent(),
                required DateTime publishedAt,
              }) => ArticlesCompanion.insert(
                id: id,
                createdAt: createdAt,
                feed: feed,
                url: url,
                title: title,
                description: description,
                thumbnailUrl: thumbnailUrl,
                status: status,
                publishedAt: publishedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ArticlesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({feed = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (feed) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.feed,
                                referencedTable: $$ArticlesTableReferences
                                    ._feedTable(db),
                                referencedColumn: $$ArticlesTableReferences
                                    ._feedTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ArticlesTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $ArticlesTable,
      Article,
      $$ArticlesTableFilterComposer,
      $$ArticlesTableOrderingComposer,
      $$ArticlesTableAnnotationComposer,
      $$ArticlesTableCreateCompanionBuilder,
      $$ArticlesTableUpdateCompanionBuilder,
      (Article, $$ArticlesTableReferences),
      Article,
      PrefetchHooks Function({bool feed})
    >;

class $DatabaseManager {
  final _$Database _db;
  $DatabaseManager(this._db);
  $$FeedsTableTableManager get feeds =>
      $$FeedsTableTableManager(_db, _db.feeds);
  $$ArticlesTableTableManager get articles =>
      $$ArticlesTableTableManager(_db, _db.articles);
}
