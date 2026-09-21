// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DuasTable extends Duas with TableInfo<$DuasTable, Dua> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DuasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _originalTextMeta = const VerificationMeta(
    'originalText',
  );
  @override
  late final GeneratedColumn<String> originalText = GeneratedColumn<String>(
    'original_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ocrTextMeta = const VerificationMeta(
    'ocrText',
  );
  @override
  late final GeneratedColumn<String> ocrText = GeneratedColumn<String>(
    'ocr_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _translationMeta = const VerificationMeta(
    'translation',
  );
  @override
  late final GeneratedColumn<String> translation = GeneratedColumn<String>(
    'translation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transliterationMeta = const VerificationMeta(
    'transliteration',
  );
  @override
  late final GeneratedColumn<String> transliteration = GeneratedColumn<String>(
    'transliteration',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsTextMeta = const VerificationMeta(
    'tagsText',
  );
  @override
  late final GeneratedColumn<String> tagsText = GeneratedColumn<String>(
    'tags_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _primaryCategoryIdMeta = const VerificationMeta(
    'primaryCategoryId',
  );
  @override
  late final GeneratedColumn<String> primaryCategoryId =
      GeneratedColumn<String>(
        'primary_category_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detectedLanguageMeta = const VerificationMeta(
    'detectedLanguage',
  );
  @override
  late final GeneratedColumn<String> detectedLanguage = GeneratedColumn<String>(
    'detected_language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduleEnabledMeta = const VerificationMeta(
    'scheduleEnabled',
  );
  @override
  late final GeneratedColumn<bool> scheduleEnabled = GeneratedColumn<bool>(
    'schedule_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("schedule_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _scheduleHourMeta = const VerificationMeta(
    'scheduleHour',
  );
  @override
  late final GeneratedColumn<int> scheduleHour = GeneratedColumn<int>(
    'schedule_hour',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduleMinuteMeta = const VerificationMeta(
    'scheduleMinute',
  );
  @override
  late final GeneratedColumn<int> scheduleMinute = GeneratedColumn<int>(
    'schedule_minute',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduleRepeatsMeta = const VerificationMeta(
    'scheduleRepeats',
  );
  @override
  late final GeneratedColumn<int> scheduleRepeats = GeneratedColumn<int>(
    'schedule_repeats',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _scheduleModeMeta = const VerificationMeta(
    'scheduleMode',
  );
  @override
  late final GeneratedColumn<String> scheduleMode = GeneratedColumn<String>(
    'schedule_mode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isBuiltInMeta = const VerificationMeta(
    'isBuiltIn',
  );
  @override
  late final GeneratedColumn<bool> isBuiltIn = GeneratedColumn<bool>(
    'is_built_in',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_built_in" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    originalText,
    ocrText,
    translation,
    transliteration,
    reference,
    notes,
    tagsText,
    primaryCategoryId,
    imagePath,
    detectedLanguage,
    scheduleEnabled,
    scheduleHour,
    scheduleMinute,
    scheduleRepeats,
    scheduleMode,
    isBuiltIn,
    isFavorite,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'duas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Dua> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('original_text')) {
      context.handle(
        _originalTextMeta,
        originalText.isAcceptableOrUnknown(
          data['original_text']!,
          _originalTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalTextMeta);
    }
    if (data.containsKey('ocr_text')) {
      context.handle(
        _ocrTextMeta,
        ocrText.isAcceptableOrUnknown(data['ocr_text']!, _ocrTextMeta),
      );
    }
    if (data.containsKey('translation')) {
      context.handle(
        _translationMeta,
        translation.isAcceptableOrUnknown(
          data['translation']!,
          _translationMeta,
        ),
      );
    }
    if (data.containsKey('transliteration')) {
      context.handle(
        _transliterationMeta,
        transliteration.isAcceptableOrUnknown(
          data['transliteration']!,
          _transliterationMeta,
        ),
      );
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('tags_text')) {
      context.handle(
        _tagsTextMeta,
        tagsText.isAcceptableOrUnknown(data['tags_text']!, _tagsTextMeta),
      );
    }
    if (data.containsKey('primary_category_id')) {
      context.handle(
        _primaryCategoryIdMeta,
        primaryCategoryId.isAcceptableOrUnknown(
          data['primary_category_id']!,
          _primaryCategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('detected_language')) {
      context.handle(
        _detectedLanguageMeta,
        detectedLanguage.isAcceptableOrUnknown(
          data['detected_language']!,
          _detectedLanguageMeta,
        ),
      );
    }
    if (data.containsKey('schedule_enabled')) {
      context.handle(
        _scheduleEnabledMeta,
        scheduleEnabled.isAcceptableOrUnknown(
          data['schedule_enabled']!,
          _scheduleEnabledMeta,
        ),
      );
    }
    if (data.containsKey('schedule_hour')) {
      context.handle(
        _scheduleHourMeta,
        scheduleHour.isAcceptableOrUnknown(
          data['schedule_hour']!,
          _scheduleHourMeta,
        ),
      );
    }
    if (data.containsKey('schedule_minute')) {
      context.handle(
        _scheduleMinuteMeta,
        scheduleMinute.isAcceptableOrUnknown(
          data['schedule_minute']!,
          _scheduleMinuteMeta,
        ),
      );
    }
    if (data.containsKey('schedule_repeats')) {
      context.handle(
        _scheduleRepeatsMeta,
        scheduleRepeats.isAcceptableOrUnknown(
          data['schedule_repeats']!,
          _scheduleRepeatsMeta,
        ),
      );
    }
    if (data.containsKey('schedule_mode')) {
      context.handle(
        _scheduleModeMeta,
        scheduleMode.isAcceptableOrUnknown(
          data['schedule_mode']!,
          _scheduleModeMeta,
        ),
      );
    }
    if (data.containsKey('is_built_in')) {
      context.handle(
        _isBuiltInMeta,
        isBuiltIn.isAcceptableOrUnknown(data['is_built_in']!, _isBuiltInMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Dua map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dua(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      originalText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_text'],
      )!,
      ocrText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ocr_text'],
      ),
      translation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation'],
      ),
      transliteration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transliteration'],
      ),
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      tagsText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_text'],
      )!,
      primaryCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_category_id'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      detectedLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detected_language'],
      ),
      scheduleEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}schedule_enabled'],
      )!,
      scheduleHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schedule_hour'],
      ),
      scheduleMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schedule_minute'],
      ),
      scheduleRepeats: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schedule_repeats'],
      )!,
      scheduleMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_mode'],
      ),
      isBuiltIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_built_in'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DuasTable createAlias(String alias) {
    return $DuasTable(attachedDatabase, alias);
  }
}

class Dua extends DataClass implements Insertable<Dua> {
  final String id;
  final String title;
  final String originalText;
  final String? ocrText;
  final String? translation;
  final String? transliteration;
  final String? reference;
  final String? notes;
  final String tagsText;
  final String? primaryCategoryId;
  final String? imagePath;
  final String? detectedLanguage;
  final bool scheduleEnabled;
  final int? scheduleHour;
  final int? scheduleMinute;
  final int scheduleRepeats;
  final String? scheduleMode;
  final bool isBuiltIn;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Dua({
    required this.id,
    required this.title,
    required this.originalText,
    this.ocrText,
    this.translation,
    this.transliteration,
    this.reference,
    this.notes,
    required this.tagsText,
    this.primaryCategoryId,
    this.imagePath,
    this.detectedLanguage,
    required this.scheduleEnabled,
    this.scheduleHour,
    this.scheduleMinute,
    required this.scheduleRepeats,
    this.scheduleMode,
    required this.isBuiltIn,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['original_text'] = Variable<String>(originalText);
    if (!nullToAbsent || ocrText != null) {
      map['ocr_text'] = Variable<String>(ocrText);
    }
    if (!nullToAbsent || translation != null) {
      map['translation'] = Variable<String>(translation);
    }
    if (!nullToAbsent || transliteration != null) {
      map['transliteration'] = Variable<String>(transliteration);
    }
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['tags_text'] = Variable<String>(tagsText);
    if (!nullToAbsent || primaryCategoryId != null) {
      map['primary_category_id'] = Variable<String>(primaryCategoryId);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || detectedLanguage != null) {
      map['detected_language'] = Variable<String>(detectedLanguage);
    }
    map['schedule_enabled'] = Variable<bool>(scheduleEnabled);
    if (!nullToAbsent || scheduleHour != null) {
      map['schedule_hour'] = Variable<int>(scheduleHour);
    }
    if (!nullToAbsent || scheduleMinute != null) {
      map['schedule_minute'] = Variable<int>(scheduleMinute);
    }
    map['schedule_repeats'] = Variable<int>(scheduleRepeats);
    if (!nullToAbsent || scheduleMode != null) {
      map['schedule_mode'] = Variable<String>(scheduleMode);
    }
    map['is_built_in'] = Variable<bool>(isBuiltIn);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DuasCompanion toCompanion(bool nullToAbsent) {
    return DuasCompanion(
      id: Value(id),
      title: Value(title),
      originalText: Value(originalText),
      ocrText: ocrText == null && nullToAbsent
          ? const Value.absent()
          : Value(ocrText),
      translation: translation == null && nullToAbsent
          ? const Value.absent()
          : Value(translation),
      transliteration: transliteration == null && nullToAbsent
          ? const Value.absent()
          : Value(transliteration),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      tagsText: Value(tagsText),
      primaryCategoryId: primaryCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryCategoryId),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      detectedLanguage: detectedLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(detectedLanguage),
      scheduleEnabled: Value(scheduleEnabled),
      scheduleHour: scheduleHour == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleHour),
      scheduleMinute: scheduleMinute == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleMinute),
      scheduleRepeats: Value(scheduleRepeats),
      scheduleMode: scheduleMode == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleMode),
      isBuiltIn: Value(isBuiltIn),
      isFavorite: Value(isFavorite),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Dua.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dua(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      originalText: serializer.fromJson<String>(json['originalText']),
      ocrText: serializer.fromJson<String?>(json['ocrText']),
      translation: serializer.fromJson<String?>(json['translation']),
      transliteration: serializer.fromJson<String?>(json['transliteration']),
      reference: serializer.fromJson<String?>(json['reference']),
      notes: serializer.fromJson<String?>(json['notes']),
      tagsText: serializer.fromJson<String>(json['tagsText']),
      primaryCategoryId: serializer.fromJson<String?>(
        json['primaryCategoryId'],
      ),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      detectedLanguage: serializer.fromJson<String?>(json['detectedLanguage']),
      scheduleEnabled: serializer.fromJson<bool>(json['scheduleEnabled']),
      scheduleHour: serializer.fromJson<int?>(json['scheduleHour']),
      scheduleMinute: serializer.fromJson<int?>(json['scheduleMinute']),
      scheduleRepeats: serializer.fromJson<int>(json['scheduleRepeats']),
      scheduleMode: serializer.fromJson<String?>(json['scheduleMode']),
      isBuiltIn: serializer.fromJson<bool>(json['isBuiltIn']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'originalText': serializer.toJson<String>(originalText),
      'ocrText': serializer.toJson<String?>(ocrText),
      'translation': serializer.toJson<String?>(translation),
      'transliteration': serializer.toJson<String?>(transliteration),
      'reference': serializer.toJson<String?>(reference),
      'notes': serializer.toJson<String?>(notes),
      'tagsText': serializer.toJson<String>(tagsText),
      'primaryCategoryId': serializer.toJson<String?>(primaryCategoryId),
      'imagePath': serializer.toJson<String?>(imagePath),
      'detectedLanguage': serializer.toJson<String?>(detectedLanguage),
      'scheduleEnabled': serializer.toJson<bool>(scheduleEnabled),
      'scheduleHour': serializer.toJson<int?>(scheduleHour),
      'scheduleMinute': serializer.toJson<int?>(scheduleMinute),
      'scheduleRepeats': serializer.toJson<int>(scheduleRepeats),
      'scheduleMode': serializer.toJson<String?>(scheduleMode),
      'isBuiltIn': serializer.toJson<bool>(isBuiltIn),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Dua copyWith({
    String? id,
    String? title,
    String? originalText,
    Value<String?> ocrText = const Value.absent(),
    Value<String?> translation = const Value.absent(),
    Value<String?> transliteration = const Value.absent(),
    Value<String?> reference = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? tagsText,
    Value<String?> primaryCategoryId = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    Value<String?> detectedLanguage = const Value.absent(),
    bool? scheduleEnabled,
    Value<int?> scheduleHour = const Value.absent(),
    Value<int?> scheduleMinute = const Value.absent(),
    int? scheduleRepeats,
    Value<String?> scheduleMode = const Value.absent(),
    bool? isBuiltIn,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Dua(
    id: id ?? this.id,
    title: title ?? this.title,
    originalText: originalText ?? this.originalText,
    ocrText: ocrText.present ? ocrText.value : this.ocrText,
    translation: translation.present ? translation.value : this.translation,
    transliteration: transliteration.present
        ? transliteration.value
        : this.transliteration,
    reference: reference.present ? reference.value : this.reference,
    notes: notes.present ? notes.value : this.notes,
    tagsText: tagsText ?? this.tagsText,
    primaryCategoryId: primaryCategoryId.present
        ? primaryCategoryId.value
        : this.primaryCategoryId,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    detectedLanguage: detectedLanguage.present
        ? detectedLanguage.value
        : this.detectedLanguage,
    scheduleEnabled: scheduleEnabled ?? this.scheduleEnabled,
    scheduleHour: scheduleHour.present ? scheduleHour.value : this.scheduleHour,
    scheduleMinute: scheduleMinute.present
        ? scheduleMinute.value
        : this.scheduleMinute,
    scheduleRepeats: scheduleRepeats ?? this.scheduleRepeats,
    scheduleMode: scheduleMode.present ? scheduleMode.value : this.scheduleMode,
    isBuiltIn: isBuiltIn ?? this.isBuiltIn,
    isFavorite: isFavorite ?? this.isFavorite,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Dua copyWithCompanion(DuasCompanion data) {
    return Dua(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      originalText: data.originalText.present
          ? data.originalText.value
          : this.originalText,
      ocrText: data.ocrText.present ? data.ocrText.value : this.ocrText,
      translation: data.translation.present
          ? data.translation.value
          : this.translation,
      transliteration: data.transliteration.present
          ? data.transliteration.value
          : this.transliteration,
      reference: data.reference.present ? data.reference.value : this.reference,
      notes: data.notes.present ? data.notes.value : this.notes,
      tagsText: data.tagsText.present ? data.tagsText.value : this.tagsText,
      primaryCategoryId: data.primaryCategoryId.present
          ? data.primaryCategoryId.value
          : this.primaryCategoryId,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      detectedLanguage: data.detectedLanguage.present
          ? data.detectedLanguage.value
          : this.detectedLanguage,
      scheduleEnabled: data.scheduleEnabled.present
          ? data.scheduleEnabled.value
          : this.scheduleEnabled,
      scheduleHour: data.scheduleHour.present
          ? data.scheduleHour.value
          : this.scheduleHour,
      scheduleMinute: data.scheduleMinute.present
          ? data.scheduleMinute.value
          : this.scheduleMinute,
      scheduleRepeats: data.scheduleRepeats.present
          ? data.scheduleRepeats.value
          : this.scheduleRepeats,
      scheduleMode: data.scheduleMode.present
          ? data.scheduleMode.value
          : this.scheduleMode,
      isBuiltIn: data.isBuiltIn.present ? data.isBuiltIn.value : this.isBuiltIn,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Dua(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('originalText: $originalText, ')
          ..write('ocrText: $ocrText, ')
          ..write('translation: $translation, ')
          ..write('transliteration: $transliteration, ')
          ..write('reference: $reference, ')
          ..write('notes: $notes, ')
          ..write('tagsText: $tagsText, ')
          ..write('primaryCategoryId: $primaryCategoryId, ')
          ..write('imagePath: $imagePath, ')
          ..write('detectedLanguage: $detectedLanguage, ')
          ..write('scheduleEnabled: $scheduleEnabled, ')
          ..write('scheduleHour: $scheduleHour, ')
          ..write('scheduleMinute: $scheduleMinute, ')
          ..write('scheduleRepeats: $scheduleRepeats, ')
          ..write('scheduleMode: $scheduleMode, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    title,
    originalText,
    ocrText,
    translation,
    transliteration,
    reference,
    notes,
    tagsText,
    primaryCategoryId,
    imagePath,
    detectedLanguage,
    scheduleEnabled,
    scheduleHour,
    scheduleMinute,
    scheduleRepeats,
    scheduleMode,
    isBuiltIn,
    isFavorite,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dua &&
          other.id == this.id &&
          other.title == this.title &&
          other.originalText == this.originalText &&
          other.ocrText == this.ocrText &&
          other.translation == this.translation &&
          other.transliteration == this.transliteration &&
          other.reference == this.reference &&
          other.notes == this.notes &&
          other.tagsText == this.tagsText &&
          other.primaryCategoryId == this.primaryCategoryId &&
          other.imagePath == this.imagePath &&
          other.detectedLanguage == this.detectedLanguage &&
          other.scheduleEnabled == this.scheduleEnabled &&
          other.scheduleHour == this.scheduleHour &&
          other.scheduleMinute == this.scheduleMinute &&
          other.scheduleRepeats == this.scheduleRepeats &&
          other.scheduleMode == this.scheduleMode &&
          other.isBuiltIn == this.isBuiltIn &&
          other.isFavorite == this.isFavorite &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DuasCompanion extends UpdateCompanion<Dua> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> originalText;
  final Value<String?> ocrText;
  final Value<String?> translation;
  final Value<String?> transliteration;
  final Value<String?> reference;
  final Value<String?> notes;
  final Value<String> tagsText;
  final Value<String?> primaryCategoryId;
  final Value<String?> imagePath;
  final Value<String?> detectedLanguage;
  final Value<bool> scheduleEnabled;
  final Value<int?> scheduleHour;
  final Value<int?> scheduleMinute;
  final Value<int> scheduleRepeats;
  final Value<String?> scheduleMode;
  final Value<bool> isBuiltIn;
  final Value<bool> isFavorite;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DuasCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.originalText = const Value.absent(),
    this.ocrText = const Value.absent(),
    this.translation = const Value.absent(),
    this.transliteration = const Value.absent(),
    this.reference = const Value.absent(),
    this.notes = const Value.absent(),
    this.tagsText = const Value.absent(),
    this.primaryCategoryId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.detectedLanguage = const Value.absent(),
    this.scheduleEnabled = const Value.absent(),
    this.scheduleHour = const Value.absent(),
    this.scheduleMinute = const Value.absent(),
    this.scheduleRepeats = const Value.absent(),
    this.scheduleMode = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DuasCompanion.insert({
    required String id,
    required String title,
    required String originalText,
    this.ocrText = const Value.absent(),
    this.translation = const Value.absent(),
    this.transliteration = const Value.absent(),
    this.reference = const Value.absent(),
    this.notes = const Value.absent(),
    this.tagsText = const Value.absent(),
    this.primaryCategoryId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.detectedLanguage = const Value.absent(),
    this.scheduleEnabled = const Value.absent(),
    this.scheduleHour = const Value.absent(),
    this.scheduleMinute = const Value.absent(),
    this.scheduleRepeats = const Value.absent(),
    this.scheduleMode = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.isFavorite = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       originalText = Value(originalText),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Dua> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? originalText,
    Expression<String>? ocrText,
    Expression<String>? translation,
    Expression<String>? transliteration,
    Expression<String>? reference,
    Expression<String>? notes,
    Expression<String>? tagsText,
    Expression<String>? primaryCategoryId,
    Expression<String>? imagePath,
    Expression<String>? detectedLanguage,
    Expression<bool>? scheduleEnabled,
    Expression<int>? scheduleHour,
    Expression<int>? scheduleMinute,
    Expression<int>? scheduleRepeats,
    Expression<String>? scheduleMode,
    Expression<bool>? isBuiltIn,
    Expression<bool>? isFavorite,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (originalText != null) 'original_text': originalText,
      if (ocrText != null) 'ocr_text': ocrText,
      if (translation != null) 'translation': translation,
      if (transliteration != null) 'transliteration': transliteration,
      if (reference != null) 'reference': reference,
      if (notes != null) 'notes': notes,
      if (tagsText != null) 'tags_text': tagsText,
      if (primaryCategoryId != null) 'primary_category_id': primaryCategoryId,
      if (imagePath != null) 'image_path': imagePath,
      if (detectedLanguage != null) 'detected_language': detectedLanguage,
      if (scheduleEnabled != null) 'schedule_enabled': scheduleEnabled,
      if (scheduleHour != null) 'schedule_hour': scheduleHour,
      if (scheduleMinute != null) 'schedule_minute': scheduleMinute,
      if (scheduleRepeats != null) 'schedule_repeats': scheduleRepeats,
      if (scheduleMode != null) 'schedule_mode': scheduleMode,
      if (isBuiltIn != null) 'is_built_in': isBuiltIn,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DuasCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? originalText,
    Value<String?>? ocrText,
    Value<String?>? translation,
    Value<String?>? transliteration,
    Value<String?>? reference,
    Value<String?>? notes,
    Value<String>? tagsText,
    Value<String?>? primaryCategoryId,
    Value<String?>? imagePath,
    Value<String?>? detectedLanguage,
    Value<bool>? scheduleEnabled,
    Value<int?>? scheduleHour,
    Value<int?>? scheduleMinute,
    Value<int>? scheduleRepeats,
    Value<String?>? scheduleMode,
    Value<bool>? isBuiltIn,
    Value<bool>? isFavorite,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DuasCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      originalText: originalText ?? this.originalText,
      ocrText: ocrText ?? this.ocrText,
      translation: translation ?? this.translation,
      transliteration: transliteration ?? this.transliteration,
      reference: reference ?? this.reference,
      notes: notes ?? this.notes,
      tagsText: tagsText ?? this.tagsText,
      primaryCategoryId: primaryCategoryId ?? this.primaryCategoryId,
      imagePath: imagePath ?? this.imagePath,
      detectedLanguage: detectedLanguage ?? this.detectedLanguage,
      scheduleEnabled: scheduleEnabled ?? this.scheduleEnabled,
      scheduleHour: scheduleHour ?? this.scheduleHour,
      scheduleMinute: scheduleMinute ?? this.scheduleMinute,
      scheduleRepeats: scheduleRepeats ?? this.scheduleRepeats,
      scheduleMode: scheduleMode ?? this.scheduleMode,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (originalText.present) {
      map['original_text'] = Variable<String>(originalText.value);
    }
    if (ocrText.present) {
      map['ocr_text'] = Variable<String>(ocrText.value);
    }
    if (translation.present) {
      map['translation'] = Variable<String>(translation.value);
    }
    if (transliteration.present) {
      map['transliteration'] = Variable<String>(transliteration.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (tagsText.present) {
      map['tags_text'] = Variable<String>(tagsText.value);
    }
    if (primaryCategoryId.present) {
      map['primary_category_id'] = Variable<String>(primaryCategoryId.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (detectedLanguage.present) {
      map['detected_language'] = Variable<String>(detectedLanguage.value);
    }
    if (scheduleEnabled.present) {
      map['schedule_enabled'] = Variable<bool>(scheduleEnabled.value);
    }
    if (scheduleHour.present) {
      map['schedule_hour'] = Variable<int>(scheduleHour.value);
    }
    if (scheduleMinute.present) {
      map['schedule_minute'] = Variable<int>(scheduleMinute.value);
    }
    if (scheduleRepeats.present) {
      map['schedule_repeats'] = Variable<int>(scheduleRepeats.value);
    }
    if (scheduleMode.present) {
      map['schedule_mode'] = Variable<String>(scheduleMode.value);
    }
    if (isBuiltIn.present) {
      map['is_built_in'] = Variable<bool>(isBuiltIn.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DuasCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('originalText: $originalText, ')
          ..write('ocrText: $ocrText, ')
          ..write('translation: $translation, ')
          ..write('transliteration: $transliteration, ')
          ..write('reference: $reference, ')
          ..write('notes: $notes, ')
          ..write('tagsText: $tagsText, ')
          ..write('primaryCategoryId: $primaryCategoryId, ')
          ..write('imagePath: $imagePath, ')
          ..write('detectedLanguage: $detectedLanguage, ')
          ..write('scheduleEnabled: $scheduleEnabled, ')
          ..write('scheduleHour: $scheduleHour, ')
          ..write('scheduleMinute: $scheduleMinute, ')
          ..write('scheduleRepeats: $scheduleRepeats, ')
          ..write('scheduleMode: $scheduleMode, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _isBuiltInMeta = const VerificationMeta(
    'isBuiltIn',
  );
  @override
  late final GeneratedColumn<bool> isBuiltIn = GeneratedColumn<bool>(
    'is_built_in',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_built_in" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    isBuiltIn,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_built_in')) {
      context.handle(
        _isBuiltInMeta,
        isBuiltIn.isAcceptableOrUnknown(data['is_built_in']!, _isBuiltInMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isBuiltIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_built_in'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String name;
  final bool isBuiltIn;
  final int sortOrder;
  final DateTime createdAt;
  const Category({
    required this.id,
    required this.name,
    required this.isBuiltIn,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['is_built_in'] = Variable<bool>(isBuiltIn);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      isBuiltIn: Value(isBuiltIn),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isBuiltIn: serializer.fromJson<bool>(json['isBuiltIn']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'isBuiltIn': serializer.toJson<bool>(isBuiltIn),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Category copyWith({
    String? id,
    String? name,
    bool? isBuiltIn,
    int? sortOrder,
    DateTime? createdAt,
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    isBuiltIn: isBuiltIn ?? this.isBuiltIn,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isBuiltIn: data.isBuiltIn.present ? data.isBuiltIn.value : this.isBuiltIn,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isBuiltIn, sortOrder, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.isBuiltIn == this.isBuiltIn &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> name;
  final Value<bool> isBuiltIn;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    this.isBuiltIn = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<bool>? isBuiltIn,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isBuiltIn != null) 'is_built_in': isBuiltIn,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<bool>? isBuiltIn,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isBuiltIn.present) {
      map['is_built_in'] = Variable<bool>(isBuiltIn.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final String id;
  final String name;
  final DateTime createdAt;
  const Tag({required this.id, required this.name, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Tag copyWith({String? id, String? name, DateTime? createdAt}) => Tag(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    required String name,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Tag> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DuaTagsTable extends DuaTags with TableInfo<$DuaTagsTable, DuaTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DuaTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _duaIdMeta = const VerificationMeta('duaId');
  @override
  late final GeneratedColumn<String> duaId = GeneratedColumn<String>(
    'dua_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES duas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [duaId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dua_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<DuaTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('dua_id')) {
      context.handle(
        _duaIdMeta,
        duaId.isAcceptableOrUnknown(data['dua_id']!, _duaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_duaIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {duaId, tagId};
  @override
  DuaTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DuaTag(
      duaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dua_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $DuaTagsTable createAlias(String alias) {
    return $DuaTagsTable(attachedDatabase, alias);
  }
}

class DuaTag extends DataClass implements Insertable<DuaTag> {
  final String duaId;
  final String tagId;
  const DuaTag({required this.duaId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['dua_id'] = Variable<String>(duaId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  DuaTagsCompanion toCompanion(bool nullToAbsent) {
    return DuaTagsCompanion(duaId: Value(duaId), tagId: Value(tagId));
  }

  factory DuaTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DuaTag(
      duaId: serializer.fromJson<String>(json['duaId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'duaId': serializer.toJson<String>(duaId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  DuaTag copyWith({String? duaId, String? tagId}) =>
      DuaTag(duaId: duaId ?? this.duaId, tagId: tagId ?? this.tagId);
  DuaTag copyWithCompanion(DuaTagsCompanion data) {
    return DuaTag(
      duaId: data.duaId.present ? data.duaId.value : this.duaId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DuaTag(')
          ..write('duaId: $duaId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(duaId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DuaTag &&
          other.duaId == this.duaId &&
          other.tagId == this.tagId);
}

class DuaTagsCompanion extends UpdateCompanion<DuaTag> {
  final Value<String> duaId;
  final Value<String> tagId;
  final Value<int> rowid;
  const DuaTagsCompanion({
    this.duaId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DuaTagsCompanion.insert({
    required String duaId,
    required String tagId,
    this.rowid = const Value.absent(),
  }) : duaId = Value(duaId),
       tagId = Value(tagId);
  static Insertable<DuaTag> custom({
    Expression<String>? duaId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (duaId != null) 'dua_id': duaId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DuaTagsCompanion copyWith({
    Value<String>? duaId,
    Value<String>? tagId,
    Value<int>? rowid,
  }) {
    return DuaTagsCompanion(
      duaId: duaId ?? this.duaId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (duaId.present) {
      map['dua_id'] = Variable<String>(duaId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DuaTagsCompanion(')
          ..write('duaId: $duaId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecordingsTable extends Recordings
    with TableInfo<$RecordingsTable, Recording> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _duaIdMeta = const VerificationMeta('duaId');
  @override
  late final GeneratedColumn<String> duaId = GeneratedColumn<String>(
    'dua_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES duas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    duaId,
    audioPath,
    durationMs,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recordings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recording> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('dua_id')) {
      context.handle(
        _duaIdMeta,
        duaId.isAcceptableOrUnknown(data['dua_id']!, _duaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_duaIdMeta);
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    } else if (isInserting) {
      context.missing(_audioPathMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recording map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recording(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      duaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dua_id'],
      )!,
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RecordingsTable createAlias(String alias) {
    return $RecordingsTable(attachedDatabase, alias);
  }
}

class Recording extends DataClass implements Insertable<Recording> {
  final String id;
  final String duaId;
  final String audioPath;
  final int durationMs;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Recording({
    required this.id,
    required this.duaId,
    required this.audioPath,
    required this.durationMs,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['dua_id'] = Variable<String>(duaId);
    map['audio_path'] = Variable<String>(audioPath);
    map['duration_ms'] = Variable<int>(durationMs);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RecordingsCompanion toCompanion(bool nullToAbsent) {
    return RecordingsCompanion(
      id: Value(id),
      duaId: Value(duaId),
      audioPath: Value(audioPath),
      durationMs: Value(durationMs),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Recording.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recording(
      id: serializer.fromJson<String>(json['id']),
      duaId: serializer.fromJson<String>(json['duaId']),
      audioPath: serializer.fromJson<String>(json['audioPath']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'duaId': serializer.toJson<String>(duaId),
      'audioPath': serializer.toJson<String>(audioPath),
      'durationMs': serializer.toJson<int>(durationMs),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Recording copyWith({
    String? id,
    String? duaId,
    String? audioPath,
    int? durationMs,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Recording(
    id: id ?? this.id,
    duaId: duaId ?? this.duaId,
    audioPath: audioPath ?? this.audioPath,
    durationMs: durationMs ?? this.durationMs,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Recording copyWithCompanion(RecordingsCompanion data) {
    return Recording(
      id: data.id.present ? data.id.value : this.id,
      duaId: data.duaId.present ? data.duaId.value : this.duaId,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recording(')
          ..write('id: $id, ')
          ..write('duaId: $duaId, ')
          ..write('audioPath: $audioPath, ')
          ..write('durationMs: $durationMs, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, duaId, audioPath, durationMs, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recording &&
          other.id == this.id &&
          other.duaId == this.duaId &&
          other.audioPath == this.audioPath &&
          other.durationMs == this.durationMs &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecordingsCompanion extends UpdateCompanion<Recording> {
  final Value<String> id;
  final Value<String> duaId;
  final Value<String> audioPath;
  final Value<int> durationMs;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RecordingsCompanion({
    this.id = const Value.absent(),
    this.duaId = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecordingsCompanion.insert({
    required String id,
    required String duaId,
    required String audioPath,
    required int durationMs,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       duaId = Value(duaId),
       audioPath = Value(audioPath),
       durationMs = Value(durationMs),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Recording> custom({
    Expression<String>? id,
    Expression<String>? duaId,
    Expression<String>? audioPath,
    Expression<int>? durationMs,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (duaId != null) 'dua_id': duaId,
      if (audioPath != null) 'audio_path': audioPath,
      if (durationMs != null) 'duration_ms': durationMs,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecordingsCompanion copyWith({
    Value<String>? id,
    Value<String>? duaId,
    Value<String>? audioPath,
    Value<int>? durationMs,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RecordingsCompanion(
      id: id ?? this.id,
      duaId: duaId ?? this.duaId,
      audioPath: audioPath ?? this.audioPath,
      durationMs: durationMs ?? this.durationMs,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (duaId.present) {
      map['dua_id'] = Variable<String>(duaId.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordingsCompanion(')
          ..write('id: $id, ')
          ..write('duaId: $duaId, ')
          ..write('audioPath: $audioPath, ')
          ..write('durationMs: $durationMs, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OcrMetadataTable extends OcrMetadata
    with TableInfo<$OcrMetadataTable, OcrMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OcrMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _duaIdMeta = const VerificationMeta('duaId');
  @override
  late final GeneratedColumn<String> duaId = GeneratedColumn<String>(
    'dua_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES duas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceImagePathMeta = const VerificationMeta(
    'sourceImagePath',
  );
  @override
  late final GeneratedColumn<String> sourceImagePath = GeneratedColumn<String>(
    'source_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    duaId,
    languageCode,
    confidence,
    sourceImagePath,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ocr_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<OcrMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('dua_id')) {
      context.handle(
        _duaIdMeta,
        duaId.isAcceptableOrUnknown(data['dua_id']!, _duaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_duaIdMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('source_image_path')) {
      context.handle(
        _sourceImagePathMeta,
        sourceImagePath.isAcceptableOrUnknown(
          data['source_image_path']!,
          _sourceImagePathMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OcrMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OcrMetadataData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      duaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dua_id'],
      )!,
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      sourceImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_image_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $OcrMetadataTable createAlias(String alias) {
    return $OcrMetadataTable(attachedDatabase, alias);
  }
}

class OcrMetadataData extends DataClass implements Insertable<OcrMetadataData> {
  final String id;
  final String duaId;
  final String? languageCode;
  final double? confidence;
  final String? sourceImagePath;
  final DateTime createdAt;
  const OcrMetadataData({
    required this.id,
    required this.duaId,
    this.languageCode,
    this.confidence,
    this.sourceImagePath,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['dua_id'] = Variable<String>(duaId);
    if (!nullToAbsent || languageCode != null) {
      map['language_code'] = Variable<String>(languageCode);
    }
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    if (!nullToAbsent || sourceImagePath != null) {
      map['source_image_path'] = Variable<String>(sourceImagePath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OcrMetadataCompanion toCompanion(bool nullToAbsent) {
    return OcrMetadataCompanion(
      id: Value(id),
      duaId: Value(duaId),
      languageCode: languageCode == null && nullToAbsent
          ? const Value.absent()
          : Value(languageCode),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      sourceImagePath: sourceImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceImagePath),
      createdAt: Value(createdAt),
    );
  }

  factory OcrMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OcrMetadataData(
      id: serializer.fromJson<String>(json['id']),
      duaId: serializer.fromJson<String>(json['duaId']),
      languageCode: serializer.fromJson<String?>(json['languageCode']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      sourceImagePath: serializer.fromJson<String?>(json['sourceImagePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'duaId': serializer.toJson<String>(duaId),
      'languageCode': serializer.toJson<String?>(languageCode),
      'confidence': serializer.toJson<double?>(confidence),
      'sourceImagePath': serializer.toJson<String?>(sourceImagePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OcrMetadataData copyWith({
    String? id,
    String? duaId,
    Value<String?> languageCode = const Value.absent(),
    Value<double?> confidence = const Value.absent(),
    Value<String?> sourceImagePath = const Value.absent(),
    DateTime? createdAt,
  }) => OcrMetadataData(
    id: id ?? this.id,
    duaId: duaId ?? this.duaId,
    languageCode: languageCode.present ? languageCode.value : this.languageCode,
    confidence: confidence.present ? confidence.value : this.confidence,
    sourceImagePath: sourceImagePath.present
        ? sourceImagePath.value
        : this.sourceImagePath,
    createdAt: createdAt ?? this.createdAt,
  );
  OcrMetadataData copyWithCompanion(OcrMetadataCompanion data) {
    return OcrMetadataData(
      id: data.id.present ? data.id.value : this.id,
      duaId: data.duaId.present ? data.duaId.value : this.duaId,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      sourceImagePath: data.sourceImagePath.present
          ? data.sourceImagePath.value
          : this.sourceImagePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OcrMetadataData(')
          ..write('id: $id, ')
          ..write('duaId: $duaId, ')
          ..write('languageCode: $languageCode, ')
          ..write('confidence: $confidence, ')
          ..write('sourceImagePath: $sourceImagePath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    duaId,
    languageCode,
    confidence,
    sourceImagePath,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OcrMetadataData &&
          other.id == this.id &&
          other.duaId == this.duaId &&
          other.languageCode == this.languageCode &&
          other.confidence == this.confidence &&
          other.sourceImagePath == this.sourceImagePath &&
          other.createdAt == this.createdAt);
}

class OcrMetadataCompanion extends UpdateCompanion<OcrMetadataData> {
  final Value<String> id;
  final Value<String> duaId;
  final Value<String?> languageCode;
  final Value<double?> confidence;
  final Value<String?> sourceImagePath;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const OcrMetadataCompanion({
    this.id = const Value.absent(),
    this.duaId = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.confidence = const Value.absent(),
    this.sourceImagePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OcrMetadataCompanion.insert({
    required String id,
    required String duaId,
    this.languageCode = const Value.absent(),
    this.confidence = const Value.absent(),
    this.sourceImagePath = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       duaId = Value(duaId),
       createdAt = Value(createdAt);
  static Insertable<OcrMetadataData> custom({
    Expression<String>? id,
    Expression<String>? duaId,
    Expression<String>? languageCode,
    Expression<double>? confidence,
    Expression<String>? sourceImagePath,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (duaId != null) 'dua_id': duaId,
      if (languageCode != null) 'language_code': languageCode,
      if (confidence != null) 'confidence': confidence,
      if (sourceImagePath != null) 'source_image_path': sourceImagePath,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OcrMetadataCompanion copyWith({
    Value<String>? id,
    Value<String>? duaId,
    Value<String?>? languageCode,
    Value<double?>? confidence,
    Value<String?>? sourceImagePath,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return OcrMetadataCompanion(
      id: id ?? this.id,
      duaId: duaId ?? this.duaId,
      languageCode: languageCode ?? this.languageCode,
      confidence: confidence ?? this.confidence,
      sourceImagePath: sourceImagePath ?? this.sourceImagePath,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (duaId.present) {
      map['dua_id'] = Variable<String>(duaId.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (sourceImagePath.present) {
      map['source_image_path'] = Variable<String>(sourceImagePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OcrMetadataCompanion(')
          ..write('id: $id, ')
          ..write('duaId: $duaId, ')
          ..write('languageCode: $languageCode, ')
          ..write('confidence: $confidence, ')
          ..write('sourceImagePath: $sourceImagePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LibraryItemsTable extends LibraryItems
    with TableInfo<$LibraryItemsTable, LibraryItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _textContentMeta = const VerificationMeta(
    'textContent',
  );
  @override
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
    'text_content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ocrTextMeta = const VerificationMeta(
    'ocrText',
  );
  @override
  late final GeneratedColumn<String> ocrText = GeneratedColumn<String>(
    'ocr_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    kind,
    filePath,
    mimeType,
    textContent,
    ocrText,
    tags,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<LibraryItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('text_content')) {
      context.handle(
        _textContentMeta,
        textContent.isAcceptableOrUnknown(
          data['text_content']!,
          _textContentMeta,
        ),
      );
    }
    if (data.containsKey('ocr_text')) {
      context.handle(
        _ocrTextMeta,
        ocrText.isAcceptableOrUnknown(data['ocr_text']!, _ocrTextMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LibraryItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      ),
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      ),
      textContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_content'],
      ),
      ocrText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ocr_text'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LibraryItemsTable createAlias(String alias) {
    return $LibraryItemsTable(attachedDatabase, alias);
  }
}

class LibraryItem extends DataClass implements Insertable<LibraryItem> {
  final String id;
  final String title;
  final String kind;
  final String? filePath;
  final String? mimeType;
  final String? textContent;
  final String? ocrText;
  final String tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LibraryItem({
    required this.id,
    required this.title,
    required this.kind,
    this.filePath,
    this.mimeType,
    this.textContent,
    this.ocrText,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    if (!nullToAbsent || textContent != null) {
      map['text_content'] = Variable<String>(textContent);
    }
    if (!nullToAbsent || ocrText != null) {
      map['ocr_text'] = Variable<String>(ocrText);
    }
    map['tags'] = Variable<String>(tags);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LibraryItemsCompanion toCompanion(bool nullToAbsent) {
    return LibraryItemsCompanion(
      id: Value(id),
      title: Value(title),
      kind: Value(kind),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      textContent: textContent == null && nullToAbsent
          ? const Value.absent()
          : Value(textContent),
      ocrText: ocrText == null && nullToAbsent
          ? const Value.absent()
          : Value(ocrText),
      tags: Value(tags),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LibraryItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryItem(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      kind: serializer.fromJson<String>(json['kind']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      textContent: serializer.fromJson<String?>(json['textContent']),
      ocrText: serializer.fromJson<String?>(json['ocrText']),
      tags: serializer.fromJson<String>(json['tags']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'kind': serializer.toJson<String>(kind),
      'filePath': serializer.toJson<String?>(filePath),
      'mimeType': serializer.toJson<String?>(mimeType),
      'textContent': serializer.toJson<String?>(textContent),
      'ocrText': serializer.toJson<String?>(ocrText),
      'tags': serializer.toJson<String>(tags),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LibraryItem copyWith({
    String? id,
    String? title,
    String? kind,
    Value<String?> filePath = const Value.absent(),
    Value<String?> mimeType = const Value.absent(),
    Value<String?> textContent = const Value.absent(),
    Value<String?> ocrText = const Value.absent(),
    String? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LibraryItem(
    id: id ?? this.id,
    title: title ?? this.title,
    kind: kind ?? this.kind,
    filePath: filePath.present ? filePath.value : this.filePath,
    mimeType: mimeType.present ? mimeType.value : this.mimeType,
    textContent: textContent.present ? textContent.value : this.textContent,
    ocrText: ocrText.present ? ocrText.value : this.ocrText,
    tags: tags ?? this.tags,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LibraryItem copyWithCompanion(LibraryItemsCompanion data) {
    return LibraryItem(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      kind: data.kind.present ? data.kind.value : this.kind,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      textContent: data.textContent.present
          ? data.textContent.value
          : this.textContent,
      ocrText: data.ocrText.present ? data.ocrText.value : this.ocrText,
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryItem(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('filePath: $filePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('textContent: $textContent, ')
          ..write('ocrText: $ocrText, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    kind,
    filePath,
    mimeType,
    textContent,
    ocrText,
    tags,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryItem &&
          other.id == this.id &&
          other.title == this.title &&
          other.kind == this.kind &&
          other.filePath == this.filePath &&
          other.mimeType == this.mimeType &&
          other.textContent == this.textContent &&
          other.ocrText == this.ocrText &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LibraryItemsCompanion extends UpdateCompanion<LibraryItem> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> kind;
  final Value<String?> filePath;
  final Value<String?> mimeType;
  final Value<String?> textContent;
  final Value<String?> ocrText;
  final Value<String> tags;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LibraryItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.kind = const Value.absent(),
    this.filePath = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.textContent = const Value.absent(),
    this.ocrText = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LibraryItemsCompanion.insert({
    required String id,
    required String title,
    required String kind,
    this.filePath = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.textContent = const Value.absent(),
    this.ocrText = const Value.absent(),
    this.tags = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       kind = Value(kind),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LibraryItem> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? kind,
    Expression<String>? filePath,
    Expression<String>? mimeType,
    Expression<String>? textContent,
    Expression<String>? ocrText,
    Expression<String>? tags,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (kind != null) 'kind': kind,
      if (filePath != null) 'file_path': filePath,
      if (mimeType != null) 'mime_type': mimeType,
      if (textContent != null) 'text_content': textContent,
      if (ocrText != null) 'ocr_text': ocrText,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LibraryItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? kind,
    Value<String?>? filePath,
    Value<String?>? mimeType,
    Value<String?>? textContent,
    Value<String?>? ocrText,
    Value<String>? tags,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LibraryItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      kind: kind ?? this.kind,
      filePath: filePath ?? this.filePath,
      mimeType: mimeType ?? this.mimeType,
      textContent: textContent ?? this.textContent,
      ocrText: ocrText ?? this.ocrText,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (textContent.present) {
      map['text_content'] = Variable<String>(textContent.value);
    }
    if (ocrText.present) {
      map['ocr_text'] = Variable<String>(ocrText.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryItemsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('filePath: $filePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('textContent: $textContent, ')
          ..write('ocrText: $ocrText, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DuaAttachmentsTable extends DuaAttachments
    with TableInfo<$DuaAttachmentsTable, DuaAttachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DuaAttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _duaIdMeta = const VerificationMeta('duaId');
  @override
  late final GeneratedColumn<String> duaId = GeneratedColumn<String>(
    'dua_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES duas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
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
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    duaId,
    kind,
    title,
    value,
    mimeType,
    durationMs,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dua_attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<DuaAttachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('dua_id')) {
      context.handle(
        _duaIdMeta,
        duaId.isAcceptableOrUnknown(data['dua_id']!, _duaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_duaIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DuaAttachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DuaAttachment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      duaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dua_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DuaAttachmentsTable createAlias(String alias) {
    return $DuaAttachmentsTable(attachedDatabase, alias);
  }
}

class DuaAttachment extends DataClass implements Insertable<DuaAttachment> {
  final String id;
  final String duaId;
  final String kind;
  final String title;
  final String value;
  final String? mimeType;
  final int? durationMs;
  final DateTime createdAt;
  const DuaAttachment({
    required this.id,
    required this.duaId,
    required this.kind,
    required this.title,
    required this.value,
    this.mimeType,
    this.durationMs,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['dua_id'] = Variable<String>(duaId);
    map['kind'] = Variable<String>(kind);
    map['title'] = Variable<String>(title);
    map['value'] = Variable<String>(value);
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DuaAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return DuaAttachmentsCompanion(
      id: Value(id),
      duaId: Value(duaId),
      kind: Value(kind),
      title: Value(title),
      value: Value(value),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      createdAt: Value(createdAt),
    );
  }

  factory DuaAttachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DuaAttachment(
      id: serializer.fromJson<String>(json['id']),
      duaId: serializer.fromJson<String>(json['duaId']),
      kind: serializer.fromJson<String>(json['kind']),
      title: serializer.fromJson<String>(json['title']),
      value: serializer.fromJson<String>(json['value']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'duaId': serializer.toJson<String>(duaId),
      'kind': serializer.toJson<String>(kind),
      'title': serializer.toJson<String>(title),
      'value': serializer.toJson<String>(value),
      'mimeType': serializer.toJson<String?>(mimeType),
      'durationMs': serializer.toJson<int?>(durationMs),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DuaAttachment copyWith({
    String? id,
    String? duaId,
    String? kind,
    String? title,
    String? value,
    Value<String?> mimeType = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    DateTime? createdAt,
  }) => DuaAttachment(
    id: id ?? this.id,
    duaId: duaId ?? this.duaId,
    kind: kind ?? this.kind,
    title: title ?? this.title,
    value: value ?? this.value,
    mimeType: mimeType.present ? mimeType.value : this.mimeType,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    createdAt: createdAt ?? this.createdAt,
  );
  DuaAttachment copyWithCompanion(DuaAttachmentsCompanion data) {
    return DuaAttachment(
      id: data.id.present ? data.id.value : this.id,
      duaId: data.duaId.present ? data.duaId.value : this.duaId,
      kind: data.kind.present ? data.kind.value : this.kind,
      title: data.title.present ? data.title.value : this.title,
      value: data.value.present ? data.value.value : this.value,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DuaAttachment(')
          ..write('id: $id, ')
          ..write('duaId: $duaId, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('value: $value, ')
          ..write('mimeType: $mimeType, ')
          ..write('durationMs: $durationMs, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    duaId,
    kind,
    title,
    value,
    mimeType,
    durationMs,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DuaAttachment &&
          other.id == this.id &&
          other.duaId == this.duaId &&
          other.kind == this.kind &&
          other.title == this.title &&
          other.value == this.value &&
          other.mimeType == this.mimeType &&
          other.durationMs == this.durationMs &&
          other.createdAt == this.createdAt);
}

class DuaAttachmentsCompanion extends UpdateCompanion<DuaAttachment> {
  final Value<String> id;
  final Value<String> duaId;
  final Value<String> kind;
  final Value<String> title;
  final Value<String> value;
  final Value<String?> mimeType;
  final Value<int?> durationMs;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DuaAttachmentsCompanion({
    this.id = const Value.absent(),
    this.duaId = const Value.absent(),
    this.kind = const Value.absent(),
    this.title = const Value.absent(),
    this.value = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DuaAttachmentsCompanion.insert({
    required String id,
    required String duaId,
    required String kind,
    required String title,
    required String value,
    this.mimeType = const Value.absent(),
    this.durationMs = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       duaId = Value(duaId),
       kind = Value(kind),
       title = Value(title),
       value = Value(value),
       createdAt = Value(createdAt);
  static Insertable<DuaAttachment> custom({
    Expression<String>? id,
    Expression<String>? duaId,
    Expression<String>? kind,
    Expression<String>? title,
    Expression<String>? value,
    Expression<String>? mimeType,
    Expression<int>? durationMs,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (duaId != null) 'dua_id': duaId,
      if (kind != null) 'kind': kind,
      if (title != null) 'title': title,
      if (value != null) 'value': value,
      if (mimeType != null) 'mime_type': mimeType,
      if (durationMs != null) 'duration_ms': durationMs,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DuaAttachmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? duaId,
    Value<String>? kind,
    Value<String>? title,
    Value<String>? value,
    Value<String?>? mimeType,
    Value<int?>? durationMs,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return DuaAttachmentsCompanion(
      id: id ?? this.id,
      duaId: duaId ?? this.duaId,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      value: value ?? this.value,
      mimeType: mimeType ?? this.mimeType,
      durationMs: durationMs ?? this.durationMs,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (duaId.present) {
      map['dua_id'] = Variable<String>(duaId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DuaAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('duaId: $duaId, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('value: $value, ')
          ..write('mimeType: $mimeType, ')
          ..write('durationMs: $durationMs, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DuasTable duas = $DuasTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $DuaTagsTable duaTags = $DuaTagsTable(this);
  late final $RecordingsTable recordings = $RecordingsTable(this);
  late final $OcrMetadataTable ocrMetadata = $OcrMetadataTable(this);
  late final $LibraryItemsTable libraryItems = $LibraryItemsTable(this);
  late final $DuaAttachmentsTable duaAttachments = $DuaAttachmentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    duas,
    categories,
    tags,
    duaTags,
    recordings,
    ocrMetadata,
    libraryItems,
    duaAttachments,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'duas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('dua_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('dua_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'duas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recordings', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'duas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ocr_metadata', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'duas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('dua_attachments', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$DuasTableCreateCompanionBuilder =
    DuasCompanion Function({
      required String id,
      required String title,
      required String originalText,
      Value<String?> ocrText,
      Value<String?> translation,
      Value<String?> transliteration,
      Value<String?> reference,
      Value<String?> notes,
      Value<String> tagsText,
      Value<String?> primaryCategoryId,
      Value<String?> imagePath,
      Value<String?> detectedLanguage,
      Value<bool> scheduleEnabled,
      Value<int?> scheduleHour,
      Value<int?> scheduleMinute,
      Value<int> scheduleRepeats,
      Value<String?> scheduleMode,
      Value<bool> isBuiltIn,
      Value<bool> isFavorite,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$DuasTableUpdateCompanionBuilder =
    DuasCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> originalText,
      Value<String?> ocrText,
      Value<String?> translation,
      Value<String?> transliteration,
      Value<String?> reference,
      Value<String?> notes,
      Value<String> tagsText,
      Value<String?> primaryCategoryId,
      Value<String?> imagePath,
      Value<String?> detectedLanguage,
      Value<bool> scheduleEnabled,
      Value<int?> scheduleHour,
      Value<int?> scheduleMinute,
      Value<int> scheduleRepeats,
      Value<String?> scheduleMode,
      Value<bool> isBuiltIn,
      Value<bool> isFavorite,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$DuasTableReferences
    extends BaseReferences<_$AppDatabase, $DuasTable, Dua> {
  $$DuasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DuaTagsTable, List<DuaTag>> _duaTagsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.duaTags,
    aliasName: 'duas__id__dua_tags__dua_id',
  );

  $$DuaTagsTableProcessedTableManager get duaTagsRefs {
    final manager = $$DuaTagsTableTableManager(
      $_db,
      $_db.duaTags,
    ).filter((f) => f.duaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_duaTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecordingsTable, List<Recording>>
  _recordingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recordings,
    aliasName: 'duas__id__recordings__dua_id',
  );

  $$RecordingsTableProcessedTableManager get recordingsRefs {
    final manager = $$RecordingsTableTableManager(
      $_db,
      $_db.recordings,
    ).filter((f) => f.duaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_recordingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OcrMetadataTable, List<OcrMetadataData>>
  _ocrMetadataRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ocrMetadata,
    aliasName: 'duas__id__ocr_metadata__dua_id',
  );

  $$OcrMetadataTableProcessedTableManager get ocrMetadataRefs {
    final manager = $$OcrMetadataTableTableManager(
      $_db,
      $_db.ocrMetadata,
    ).filter((f) => f.duaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ocrMetadataRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DuaAttachmentsTable, List<DuaAttachment>>
  _duaAttachmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.duaAttachments,
    aliasName: 'duas__id__dua_attachments__dua_id',
  );

  $$DuaAttachmentsTableProcessedTableManager get duaAttachmentsRefs {
    final manager = $$DuaAttachmentsTableTableManager(
      $_db,
      $_db.duaAttachments,
    ).filter((f) => f.duaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_duaAttachmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DuasTableFilterComposer extends Composer<_$AppDatabase, $DuasTable> {
  $$DuasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalText => $composableBuilder(
    column: $table.originalText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ocrText => $composableBuilder(
    column: $table.ocrText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsText => $composableBuilder(
    column: $table.tagsText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryCategoryId => $composableBuilder(
    column: $table.primaryCategoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detectedLanguage => $composableBuilder(
    column: $table.detectedLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get scheduleEnabled => $composableBuilder(
    column: $table.scheduleEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduleHour => $composableBuilder(
    column: $table.scheduleHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduleMinute => $composableBuilder(
    column: $table.scheduleMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduleRepeats => $composableBuilder(
    column: $table.scheduleRepeats,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduleMode => $composableBuilder(
    column: $table.scheduleMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> duaTagsRefs(
    Expression<bool> Function($$DuaTagsTableFilterComposer f) f,
  ) {
    final $$DuaTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.duaTags,
      getReferencedColumn: (t) => t.duaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuaTagsTableFilterComposer(
            $db: $db,
            $table: $db.duaTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recordingsRefs(
    Expression<bool> Function($$RecordingsTableFilterComposer f) f,
  ) {
    final $$RecordingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recordings,
      getReferencedColumn: (t) => t.duaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordingsTableFilterComposer(
            $db: $db,
            $table: $db.recordings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ocrMetadataRefs(
    Expression<bool> Function($$OcrMetadataTableFilterComposer f) f,
  ) {
    final $$OcrMetadataTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ocrMetadata,
      getReferencedColumn: (t) => t.duaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OcrMetadataTableFilterComposer(
            $db: $db,
            $table: $db.ocrMetadata,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> duaAttachmentsRefs(
    Expression<bool> Function($$DuaAttachmentsTableFilterComposer f) f,
  ) {
    final $$DuaAttachmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.duaAttachments,
      getReferencedColumn: (t) => t.duaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuaAttachmentsTableFilterComposer(
            $db: $db,
            $table: $db.duaAttachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DuasTableOrderingComposer extends Composer<_$AppDatabase, $DuasTable> {
  $$DuasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalText => $composableBuilder(
    column: $table.originalText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ocrText => $composableBuilder(
    column: $table.ocrText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsText => $composableBuilder(
    column: $table.tagsText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryCategoryId => $composableBuilder(
    column: $table.primaryCategoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detectedLanguage => $composableBuilder(
    column: $table.detectedLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get scheduleEnabled => $composableBuilder(
    column: $table.scheduleEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduleHour => $composableBuilder(
    column: $table.scheduleHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduleMinute => $composableBuilder(
    column: $table.scheduleMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduleRepeats => $composableBuilder(
    column: $table.scheduleRepeats,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduleMode => $composableBuilder(
    column: $table.scheduleMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DuasTableAnnotationComposer
    extends Composer<_$AppDatabase, $DuasTable> {
  $$DuasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get originalText => $composableBuilder(
    column: $table.originalText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ocrText =>
      $composableBuilder(column: $table.ocrText, builder: (column) => column);

  GeneratedColumn<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get tagsText =>
      $composableBuilder(column: $table.tagsText, builder: (column) => column);

  GeneratedColumn<String> get primaryCategoryId => $composableBuilder(
    column: $table.primaryCategoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get detectedLanguage => $composableBuilder(
    column: $table.detectedLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get scheduleEnabled => $composableBuilder(
    column: $table.scheduleEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scheduleHour => $composableBuilder(
    column: $table.scheduleHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scheduleMinute => $composableBuilder(
    column: $table.scheduleMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scheduleRepeats => $composableBuilder(
    column: $table.scheduleRepeats,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scheduleMode => $composableBuilder(
    column: $table.scheduleMode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isBuiltIn =>
      $composableBuilder(column: $table.isBuiltIn, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> duaTagsRefs<T extends Object>(
    Expression<T> Function($$DuaTagsTableAnnotationComposer a) f,
  ) {
    final $$DuaTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.duaTags,
      getReferencedColumn: (t) => t.duaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuaTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.duaTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recordingsRefs<T extends Object>(
    Expression<T> Function($$RecordingsTableAnnotationComposer a) f,
  ) {
    final $$RecordingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recordings,
      getReferencedColumn: (t) => t.duaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordingsTableAnnotationComposer(
            $db: $db,
            $table: $db.recordings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ocrMetadataRefs<T extends Object>(
    Expression<T> Function($$OcrMetadataTableAnnotationComposer a) f,
  ) {
    final $$OcrMetadataTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ocrMetadata,
      getReferencedColumn: (t) => t.duaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OcrMetadataTableAnnotationComposer(
            $db: $db,
            $table: $db.ocrMetadata,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> duaAttachmentsRefs<T extends Object>(
    Expression<T> Function($$DuaAttachmentsTableAnnotationComposer a) f,
  ) {
    final $$DuaAttachmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.duaAttachments,
      getReferencedColumn: (t) => t.duaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuaAttachmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.duaAttachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DuasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DuasTable,
          Dua,
          $$DuasTableFilterComposer,
          $$DuasTableOrderingComposer,
          $$DuasTableAnnotationComposer,
          $$DuasTableCreateCompanionBuilder,
          $$DuasTableUpdateCompanionBuilder,
          (Dua, $$DuasTableReferences),
          Dua,
          PrefetchHooks Function({
            bool duaTagsRefs,
            bool recordingsRefs,
            bool ocrMetadataRefs,
            bool duaAttachmentsRefs,
          })
        > {
  $$DuasTableTableManager(_$AppDatabase db, $DuasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DuasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DuasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DuasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> originalText = const Value.absent(),
                Value<String?> ocrText = const Value.absent(),
                Value<String?> translation = const Value.absent(),
                Value<String?> transliteration = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> tagsText = const Value.absent(),
                Value<String?> primaryCategoryId = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> detectedLanguage = const Value.absent(),
                Value<bool> scheduleEnabled = const Value.absent(),
                Value<int?> scheduleHour = const Value.absent(),
                Value<int?> scheduleMinute = const Value.absent(),
                Value<int> scheduleRepeats = const Value.absent(),
                Value<String?> scheduleMode = const Value.absent(),
                Value<bool> isBuiltIn = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DuasCompanion(
                id: id,
                title: title,
                originalText: originalText,
                ocrText: ocrText,
                translation: translation,
                transliteration: transliteration,
                reference: reference,
                notes: notes,
                tagsText: tagsText,
                primaryCategoryId: primaryCategoryId,
                imagePath: imagePath,
                detectedLanguage: detectedLanguage,
                scheduleEnabled: scheduleEnabled,
                scheduleHour: scheduleHour,
                scheduleMinute: scheduleMinute,
                scheduleRepeats: scheduleRepeats,
                scheduleMode: scheduleMode,
                isBuiltIn: isBuiltIn,
                isFavorite: isFavorite,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String originalText,
                Value<String?> ocrText = const Value.absent(),
                Value<String?> translation = const Value.absent(),
                Value<String?> transliteration = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> tagsText = const Value.absent(),
                Value<String?> primaryCategoryId = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> detectedLanguage = const Value.absent(),
                Value<bool> scheduleEnabled = const Value.absent(),
                Value<int?> scheduleHour = const Value.absent(),
                Value<int?> scheduleMinute = const Value.absent(),
                Value<int> scheduleRepeats = const Value.absent(),
                Value<String?> scheduleMode = const Value.absent(),
                Value<bool> isBuiltIn = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DuasCompanion.insert(
                id: id,
                title: title,
                originalText: originalText,
                ocrText: ocrText,
                translation: translation,
                transliteration: transliteration,
                reference: reference,
                notes: notes,
                tagsText: tagsText,
                primaryCategoryId: primaryCategoryId,
                imagePath: imagePath,
                detectedLanguage: detectedLanguage,
                scheduleEnabled: scheduleEnabled,
                scheduleHour: scheduleHour,
                scheduleMinute: scheduleMinute,
                scheduleRepeats: scheduleRepeats,
                scheduleMode: scheduleMode,
                isBuiltIn: isBuiltIn,
                isFavorite: isFavorite,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DuasTable, Dua>(table),
                  $$DuasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                duaTagsRefs = false,
                recordingsRefs = false,
                ocrMetadataRefs = false,
                duaAttachmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (duaTagsRefs) db.duaTags,
                    if (recordingsRefs) db.recordings,
                    if (ocrMetadataRefs) db.ocrMetadata,
                    if (duaAttachmentsRefs) db.duaAttachments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (duaTagsRefs)
                        await $_getPrefetchedData<Dua, $DuasTable, DuaTag>(
                          currentTable: table,
                          referencedTable: $$DuasTableReferences
                              ._duaTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DuasTableReferences(db, table, p0).duaTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.duaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recordingsRefs)
                        await $_getPrefetchedData<Dua, $DuasTable, Recording>(
                          currentTable: table,
                          referencedTable: $$DuasTableReferences
                              ._recordingsRefsTable(db),
                          managerFromTypedResult: (p0) => $$DuasTableReferences(
                            db,
                            table,
                            p0,
                          ).recordingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.duaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ocrMetadataRefs)
                        await $_getPrefetchedData<
                          Dua,
                          $DuasTable,
                          OcrMetadataData
                        >(
                          currentTable: table,
                          referencedTable: $$DuasTableReferences
                              ._ocrMetadataRefsTable(db),
                          managerFromTypedResult: (p0) => $$DuasTableReferences(
                            db,
                            table,
                            p0,
                          ).ocrMetadataRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.duaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (duaAttachmentsRefs)
                        await $_getPrefetchedData<
                          Dua,
                          $DuasTable,
                          DuaAttachment
                        >(
                          currentTable: table,
                          referencedTable: $$DuasTableReferences
                              ._duaAttachmentsRefsTable(db),
                          managerFromTypedResult: (p0) => $$DuasTableReferences(
                            db,
                            table,
                            p0,
                          ).duaAttachmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.duaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DuasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DuasTable,
      Dua,
      $$DuasTableFilterComposer,
      $$DuasTableOrderingComposer,
      $$DuasTableAnnotationComposer,
      $$DuasTableCreateCompanionBuilder,
      $$DuasTableUpdateCompanionBuilder,
      (Dua, $$DuasTableReferences),
      Dua,
      PrefetchHooks Function({
        bool duaTagsRefs,
        bool recordingsRefs,
        bool ocrMetadataRefs,
        bool duaAttachmentsRefs,
      })
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      required String name,
      Value<bool> isBuiltIn,
      Value<int> sortOrder,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<bool> isBuiltIn,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isBuiltIn =>
      $composableBuilder(column: $table.isBuiltIn, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isBuiltIn = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                isBuiltIn: isBuiltIn,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<bool> isBuiltIn = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                isBuiltIn: isBuiltIn,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, Category>(table),
                  BaseReferences<_$AppDatabase, $CategoriesTable, Category>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      required String id,
      required String name,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DuaTagsTable, List<DuaTag>> _duaTagsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.duaTags,
    aliasName: 'tags__id__dua_tags__tag_id',
  );

  $$DuaTagsTableProcessedTableManager get duaTagsRefs {
    final manager = $$DuaTagsTableTableManager(
      $_db,
      $_db.duaTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_duaTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> duaTagsRefs(
    Expression<bool> Function($$DuaTagsTableFilterComposer f) f,
  ) {
    final $$DuaTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.duaTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuaTagsTableFilterComposer(
            $db: $db,
            $table: $db.duaTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> duaTagsRefs<T extends Object>(
    Expression<T> Function($$DuaTagsTableAnnotationComposer a) f,
  ) {
    final $$DuaTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.duaTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuaTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.duaTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool duaTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TagsTable, Tag>(table),
                  $$TagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({duaTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (duaTagsRefs) db.duaTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (duaTagsRefs)
                    await $_getPrefetchedData<Tag, $TagsTable, DuaTag>(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences._duaTagsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$TagsTableReferences(db, table, p0).duaTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool duaTagsRefs})
    >;
typedef $$DuaTagsTableCreateCompanionBuilder =
    DuaTagsCompanion Function({
      required String duaId,
      required String tagId,
      Value<int> rowid,
    });
typedef $$DuaTagsTableUpdateCompanionBuilder =
    DuaTagsCompanion Function({
      Value<String> duaId,
      Value<String> tagId,
      Value<int> rowid,
    });

final class $$DuaTagsTableReferences
    extends BaseReferences<_$AppDatabase, $DuaTagsTable, DuaTag> {
  $$DuaTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DuasTable _duaIdTable(_$AppDatabase db) =>
      db.duas.createAlias('dua_tags__dua_id__duas__id');

  $$DuasTableProcessedTableManager get duaId {
    final $_column = $_itemColumn<String>('dua_id')!;

    final manager = $$DuasTableTableManager(
      $_db,
      $_db.duas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_duaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias('dua_tags__tag_id__tags__id');

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DuaTagsTableFilterComposer
    extends Composer<_$AppDatabase, $DuaTagsTable> {
  $$DuaTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$DuasTableFilterComposer get duaId {
    final $$DuasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableFilterComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DuaTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $DuaTagsTable> {
  $$DuaTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$DuasTableOrderingComposer get duaId {
    final $$DuasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableOrderingComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DuaTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DuaTagsTable> {
  $$DuaTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$DuasTableAnnotationComposer get duaId {
    final $$DuasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableAnnotationComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DuaTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DuaTagsTable,
          DuaTag,
          $$DuaTagsTableFilterComposer,
          $$DuaTagsTableOrderingComposer,
          $$DuaTagsTableAnnotationComposer,
          $$DuaTagsTableCreateCompanionBuilder,
          $$DuaTagsTableUpdateCompanionBuilder,
          (DuaTag, $$DuaTagsTableReferences),
          DuaTag,
          PrefetchHooks Function({bool duaId, bool tagId})
        > {
  $$DuaTagsTableTableManager(_$AppDatabase db, $DuaTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DuaTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DuaTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DuaTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> duaId = const Value.absent(),
                Value<String> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DuaTagsCompanion(duaId: duaId, tagId: tagId, rowid: rowid),
          createCompanionCallback:
              ({
                required String duaId,
                required String tagId,
                Value<int> rowid = const Value.absent(),
              }) => DuaTagsCompanion.insert(
                duaId: duaId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DuaTagsTable, DuaTag>(table),
                  $$DuaTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({duaId = false, tagId = false}) {
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
                    if (duaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.duaId,
                                referencedTable: $$DuaTagsTableReferences
                                    ._duaIdTable(db),
                                referencedColumn: $$DuaTagsTableReferences
                                    ._duaIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable: $$DuaTagsTableReferences
                                    ._tagIdTable(db),
                                referencedColumn: $$DuaTagsTableReferences
                                    ._tagIdTable(db)
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

typedef $$DuaTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DuaTagsTable,
      DuaTag,
      $$DuaTagsTableFilterComposer,
      $$DuaTagsTableOrderingComposer,
      $$DuaTagsTableAnnotationComposer,
      $$DuaTagsTableCreateCompanionBuilder,
      $$DuaTagsTableUpdateCompanionBuilder,
      (DuaTag, $$DuaTagsTableReferences),
      DuaTag,
      PrefetchHooks Function({bool duaId, bool tagId})
    >;
typedef $$RecordingsTableCreateCompanionBuilder =
    RecordingsCompanion Function({
      required String id,
      required String duaId,
      required String audioPath,
      required int durationMs,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RecordingsTableUpdateCompanionBuilder =
    RecordingsCompanion Function({
      Value<String> id,
      Value<String> duaId,
      Value<String> audioPath,
      Value<int> durationMs,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RecordingsTableReferences
    extends BaseReferences<_$AppDatabase, $RecordingsTable, Recording> {
  $$RecordingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DuasTable _duaIdTable(_$AppDatabase db) =>
      db.duas.createAlias('recordings__dua_id__duas__id');

  $$DuasTableProcessedTableManager get duaId {
    final $_column = $_itemColumn<String>('dua_id')!;

    final manager = $$DuasTableTableManager(
      $_db,
      $_db.duas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_duaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecordingsTableFilterComposer
    extends Composer<_$AppDatabase, $RecordingsTable> {
  $$RecordingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DuasTableFilterComposer get duaId {
    final $$DuasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableFilterComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordingsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecordingsTable> {
  $$RecordingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DuasTableOrderingComposer get duaId {
    final $$DuasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableOrderingComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecordingsTable> {
  $$RecordingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DuasTableAnnotationComposer get duaId {
    final $$DuasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableAnnotationComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecordingsTable,
          Recording,
          $$RecordingsTableFilterComposer,
          $$RecordingsTableOrderingComposer,
          $$RecordingsTableAnnotationComposer,
          $$RecordingsTableCreateCompanionBuilder,
          $$RecordingsTableUpdateCompanionBuilder,
          (Recording, $$RecordingsTableReferences),
          Recording,
          PrefetchHooks Function({bool duaId})
        > {
  $$RecordingsTableTableManager(_$AppDatabase db, $RecordingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecordingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecordingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecordingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> duaId = const Value.absent(),
                Value<String> audioPath = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordingsCompanion(
                id: id,
                duaId: duaId,
                audioPath: audioPath,
                durationMs: durationMs,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String duaId,
                required String audioPath,
                required int durationMs,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RecordingsCompanion.insert(
                id: id,
                duaId: duaId,
                audioPath: audioPath,
                durationMs: durationMs,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecordingsTable, Recording>(table),
                  $$RecordingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({duaId = false}) {
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
                    if (duaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.duaId,
                                referencedTable: $$RecordingsTableReferences
                                    ._duaIdTable(db),
                                referencedColumn: $$RecordingsTableReferences
                                    ._duaIdTable(db)
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

typedef $$RecordingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecordingsTable,
      Recording,
      $$RecordingsTableFilterComposer,
      $$RecordingsTableOrderingComposer,
      $$RecordingsTableAnnotationComposer,
      $$RecordingsTableCreateCompanionBuilder,
      $$RecordingsTableUpdateCompanionBuilder,
      (Recording, $$RecordingsTableReferences),
      Recording,
      PrefetchHooks Function({bool duaId})
    >;
typedef $$OcrMetadataTableCreateCompanionBuilder =
    OcrMetadataCompanion Function({
      required String id,
      required String duaId,
      Value<String?> languageCode,
      Value<double?> confidence,
      Value<String?> sourceImagePath,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$OcrMetadataTableUpdateCompanionBuilder =
    OcrMetadataCompanion Function({
      Value<String> id,
      Value<String> duaId,
      Value<String?> languageCode,
      Value<double?> confidence,
      Value<String?> sourceImagePath,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$OcrMetadataTableReferences
    extends BaseReferences<_$AppDatabase, $OcrMetadataTable, OcrMetadataData> {
  $$OcrMetadataTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DuasTable _duaIdTable(_$AppDatabase db) =>
      db.duas.createAlias('ocr_metadata__dua_id__duas__id');

  $$DuasTableProcessedTableManager get duaId {
    final $_column = $_itemColumn<String>('dua_id')!;

    final manager = $$DuasTableTableManager(
      $_db,
      $_db.duas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_duaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OcrMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $OcrMetadataTable> {
  $$OcrMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceImagePath => $composableBuilder(
    column: $table.sourceImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DuasTableFilterComposer get duaId {
    final $$DuasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableFilterComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OcrMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $OcrMetadataTable> {
  $$OcrMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceImagePath => $composableBuilder(
    column: $table.sourceImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DuasTableOrderingComposer get duaId {
    final $$DuasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableOrderingComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OcrMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $OcrMetadataTable> {
  $$OcrMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceImagePath => $composableBuilder(
    column: $table.sourceImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DuasTableAnnotationComposer get duaId {
    final $$DuasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableAnnotationComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OcrMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OcrMetadataTable,
          OcrMetadataData,
          $$OcrMetadataTableFilterComposer,
          $$OcrMetadataTableOrderingComposer,
          $$OcrMetadataTableAnnotationComposer,
          $$OcrMetadataTableCreateCompanionBuilder,
          $$OcrMetadataTableUpdateCompanionBuilder,
          (OcrMetadataData, $$OcrMetadataTableReferences),
          OcrMetadataData,
          PrefetchHooks Function({bool duaId})
        > {
  $$OcrMetadataTableTableManager(_$AppDatabase db, $OcrMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OcrMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OcrMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OcrMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> duaId = const Value.absent(),
                Value<String?> languageCode = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String?> sourceImagePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OcrMetadataCompanion(
                id: id,
                duaId: duaId,
                languageCode: languageCode,
                confidence: confidence,
                sourceImagePath: sourceImagePath,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String duaId,
                Value<String?> languageCode = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String?> sourceImagePath = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => OcrMetadataCompanion.insert(
                id: id,
                duaId: duaId,
                languageCode: languageCode,
                confidence: confidence,
                sourceImagePath: sourceImagePath,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OcrMetadataTable, OcrMetadataData>(table),
                  $$OcrMetadataTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({duaId = false}) {
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
                    if (duaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.duaId,
                                referencedTable: $$OcrMetadataTableReferences
                                    ._duaIdTable(db),
                                referencedColumn: $$OcrMetadataTableReferences
                                    ._duaIdTable(db)
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

typedef $$OcrMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OcrMetadataTable,
      OcrMetadataData,
      $$OcrMetadataTableFilterComposer,
      $$OcrMetadataTableOrderingComposer,
      $$OcrMetadataTableAnnotationComposer,
      $$OcrMetadataTableCreateCompanionBuilder,
      $$OcrMetadataTableUpdateCompanionBuilder,
      (OcrMetadataData, $$OcrMetadataTableReferences),
      OcrMetadataData,
      PrefetchHooks Function({bool duaId})
    >;
typedef $$LibraryItemsTableCreateCompanionBuilder =
    LibraryItemsCompanion Function({
      required String id,
      required String title,
      required String kind,
      Value<String?> filePath,
      Value<String?> mimeType,
      Value<String?> textContent,
      Value<String?> ocrText,
      Value<String> tags,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LibraryItemsTableUpdateCompanionBuilder =
    LibraryItemsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> kind,
      Value<String?> filePath,
      Value<String?> mimeType,
      Value<String?> textContent,
      Value<String?> ocrText,
      Value<String> tags,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LibraryItemsTableFilterComposer
    extends Composer<_$AppDatabase, $LibraryItemsTable> {
  $$LibraryItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ocrText => $composableBuilder(
    column: $table.ocrText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LibraryItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $LibraryItemsTable> {
  $$LibraryItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ocrText => $composableBuilder(
    column: $table.ocrText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LibraryItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LibraryItemsTable> {
  $$LibraryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ocrText =>
      $composableBuilder(column: $table.ocrText, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LibraryItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LibraryItemsTable,
          LibraryItem,
          $$LibraryItemsTableFilterComposer,
          $$LibraryItemsTableOrderingComposer,
          $$LibraryItemsTableAnnotationComposer,
          $$LibraryItemsTableCreateCompanionBuilder,
          $$LibraryItemsTableUpdateCompanionBuilder,
          (
            LibraryItem,
            BaseReferences<_$AppDatabase, $LibraryItemsTable, LibraryItem>,
          ),
          LibraryItem,
          PrefetchHooks Function()
        > {
  $$LibraryItemsTableTableManager(_$AppDatabase db, $LibraryItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibraryItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibraryItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibraryItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<String?> textContent = const Value.absent(),
                Value<String?> ocrText = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LibraryItemsCompanion(
                id: id,
                title: title,
                kind: kind,
                filePath: filePath,
                mimeType: mimeType,
                textContent: textContent,
                ocrText: ocrText,
                tags: tags,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String kind,
                Value<String?> filePath = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<String?> textContent = const Value.absent(),
                Value<String?> ocrText = const Value.absent(),
                Value<String> tags = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LibraryItemsCompanion.insert(
                id: id,
                title: title,
                kind: kind,
                filePath: filePath,
                mimeType: mimeType,
                textContent: textContent,
                ocrText: ocrText,
                tags: tags,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LibraryItemsTable, LibraryItem>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LibraryItemsTable,
                    LibraryItem
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LibraryItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LibraryItemsTable,
      LibraryItem,
      $$LibraryItemsTableFilterComposer,
      $$LibraryItemsTableOrderingComposer,
      $$LibraryItemsTableAnnotationComposer,
      $$LibraryItemsTableCreateCompanionBuilder,
      $$LibraryItemsTableUpdateCompanionBuilder,
      (
        LibraryItem,
        BaseReferences<_$AppDatabase, $LibraryItemsTable, LibraryItem>,
      ),
      LibraryItem,
      PrefetchHooks Function()
    >;
typedef $$DuaAttachmentsTableCreateCompanionBuilder =
    DuaAttachmentsCompanion Function({
      required String id,
      required String duaId,
      required String kind,
      required String title,
      required String value,
      Value<String?> mimeType,
      Value<int?> durationMs,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$DuaAttachmentsTableUpdateCompanionBuilder =
    DuaAttachmentsCompanion Function({
      Value<String> id,
      Value<String> duaId,
      Value<String> kind,
      Value<String> title,
      Value<String> value,
      Value<String?> mimeType,
      Value<int?> durationMs,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$DuaAttachmentsTableReferences
    extends BaseReferences<_$AppDatabase, $DuaAttachmentsTable, DuaAttachment> {
  $$DuaAttachmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DuasTable _duaIdTable(_$AppDatabase db) =>
      db.duas.createAlias('dua_attachments__dua_id__duas__id');

  $$DuasTableProcessedTableManager get duaId {
    final $_column = $_itemColumn<String>('dua_id')!;

    final manager = $$DuasTableTableManager(
      $_db,
      $_db.duas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_duaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DuaAttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $DuaAttachmentsTable> {
  $$DuaAttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DuasTableFilterComposer get duaId {
    final $$DuasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableFilterComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DuaAttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DuaAttachmentsTable> {
  $$DuaAttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DuasTableOrderingComposer get duaId {
    final $$DuasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableOrderingComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DuaAttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DuaAttachmentsTable> {
  $$DuaAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DuasTableAnnotationComposer get duaId {
    final $$DuasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableAnnotationComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DuaAttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DuaAttachmentsTable,
          DuaAttachment,
          $$DuaAttachmentsTableFilterComposer,
          $$DuaAttachmentsTableOrderingComposer,
          $$DuaAttachmentsTableAnnotationComposer,
          $$DuaAttachmentsTableCreateCompanionBuilder,
          $$DuaAttachmentsTableUpdateCompanionBuilder,
          (DuaAttachment, $$DuaAttachmentsTableReferences),
          DuaAttachment,
          PrefetchHooks Function({bool duaId})
        > {
  $$DuaAttachmentsTableTableManager(
    _$AppDatabase db,
    $DuaAttachmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DuaAttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DuaAttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DuaAttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> duaId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DuaAttachmentsCompanion(
                id: id,
                duaId: duaId,
                kind: kind,
                title: title,
                value: value,
                mimeType: mimeType,
                durationMs: durationMs,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String duaId,
                required String kind,
                required String title,
                required String value,
                Value<String?> mimeType = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => DuaAttachmentsCompanion.insert(
                id: id,
                duaId: duaId,
                kind: kind,
                title: title,
                value: value,
                mimeType: mimeType,
                durationMs: durationMs,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DuaAttachmentsTable, DuaAttachment>(table),
                  $$DuaAttachmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({duaId = false}) {
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
                    if (duaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.duaId,
                                referencedTable: $$DuaAttachmentsTableReferences
                                    ._duaIdTable(db),
                                referencedColumn:
                                    $$DuaAttachmentsTableReferences
                                        ._duaIdTable(db)
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

typedef $$DuaAttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DuaAttachmentsTable,
      DuaAttachment,
      $$DuaAttachmentsTableFilterComposer,
      $$DuaAttachmentsTableOrderingComposer,
      $$DuaAttachmentsTableAnnotationComposer,
      $$DuaAttachmentsTableCreateCompanionBuilder,
      $$DuaAttachmentsTableUpdateCompanionBuilder,
      (DuaAttachment, $$DuaAttachmentsTableReferences),
      DuaAttachment,
      PrefetchHooks Function({bool duaId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DuasTableTableManager get duas => $$DuasTableTableManager(_db, _db.duas);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$DuaTagsTableTableManager get duaTags =>
      $$DuaTagsTableTableManager(_db, _db.duaTags);
  $$RecordingsTableTableManager get recordings =>
      $$RecordingsTableTableManager(_db, _db.recordings);
  $$OcrMetadataTableTableManager get ocrMetadata =>
      $$OcrMetadataTableTableManager(_db, _db.ocrMetadata);
  $$LibraryItemsTableTableManager get libraryItems =>
      $$LibraryItemsTableTableManager(_db, _db.libraryItems);
  $$DuaAttachmentsTableTableManager get duaAttachments =>
      $$DuaAttachmentsTableTableManager(_db, _db.duaAttachments);
}
