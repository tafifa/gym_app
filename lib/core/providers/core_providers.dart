import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../config/environment_config.dart';
import '../database/objectbox_service.dart';
import '../network/dio_client.dart';

/// Provider for the ObjectBoxService instance.
/// Must be overridden in main.dart with the initialized instance.
final objectBoxProvider = Provider<ObjectBoxService>((ref) {
  throw UnimplementedError('ObjectBoxService has not been initialized');
});

/// Provider for DioClient wrapper.
final dioClientProvider = Provider<DioClient>((ref) {
  final env = ref.watch(environmentProvider);
  return DioClient(baseUrl: env.baseUrl);
});

/// Provider for the Dio instance itself.
final dioProvider = Provider<Dio>((ref) {
  return ref.watch(dioClientProvider).dio;
});
