/// RTDB snapshots come back as `Map<Object?, Object?>` / `List<Object?>`.
/// Converts them to JSON-shaped values that json_serializable understands.
Object? normalizeJson(Object? value) {
  if (value is Map) {
    return <String, dynamic>{
      for (final entry in value.entries)
        if (entry.value != null) entry.key.toString(): normalizeJson(entry.value),
    };
  }
  if (value is List) return value.map(normalizeJson).toList();
  return value;
}

Map<String, dynamic>? jsonMapOrNull(Object? value) {
  final normalized = normalizeJson(value);
  return normalized is Map<String, dynamic> ? normalized : null;
}
