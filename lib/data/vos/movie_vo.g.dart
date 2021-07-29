// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieVOAdapter extends TypeAdapter<MovieVO> {
  @override
  final int typeId = 4;

  @override
  MovieVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieVO(
      id: fields[0] as int,
      originalTitle: fields[1] as String,
      releaseDate: fields[2] as String,
      genres: (fields[3] as List).cast<String>(),
      overview: fields[4] as String?,
      rating: fields[5] as double?,
      runtime: fields[6] as int?,
      posterPath: fields[7] as String,
      casts: (fields[8] as List?)?.cast<CastVO>(),
      isNowPlaying: fields[9] as bool?,
      isComingSoon: fields[10] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieVO obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.originalTitle)
      ..writeByte(2)
      ..write(obj.releaseDate)
      ..writeByte(3)
      ..write(obj.genres)
      ..writeByte(4)
      ..write(obj.overview)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.runtime)
      ..writeByte(7)
      ..write(obj.posterPath)
      ..writeByte(8)
      ..write(obj.casts)
      ..writeByte(9)
      ..write(obj.isNowPlaying)
      ..writeByte(10)
      ..write(obj.isComingSoon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieVO _$MovieVOFromJson(Map<String, dynamic> json) {
  return MovieVO(
    id: json['id'] as int,
    originalTitle: json['original_title'] as String,
    releaseDate: json['release_date'] as String,
    genres: (json['genres'] as List<dynamic>).map((e) => e as String).toList(),
    overview: json['overview'] as String?,
    rating: (json['rating'] as num?)?.toDouble(),
    runtime: json['runtime'] as int?,
    posterPath: json['poster_path'] as String,
    casts: (json['casts'] as List<dynamic>?)
        ?.map((e) => CastVO.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$MovieVOToJson(MovieVO instance) => <String, dynamic>{
      'id': instance.id,
      'original_title': instance.originalTitle,
      'release_date': instance.releaseDate,
      'genres': instance.genres,
      'overview': instance.overview,
      'rating': instance.rating,
      'runtime': instance.runtime,
      'poster_path': instance.posterPath,
      'casts': instance.casts,
    };
