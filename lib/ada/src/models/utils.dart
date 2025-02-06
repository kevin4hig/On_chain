import 'package:blockchain_utils/utils/utils.dart';
import 'package:blockchain_utils/exception/exceptions.dart';
import 'package:on_chain/ada/src/exception/exception.dart';

class AdaTransactionUtils {
  static List<int> validateFixedLengthBytes(
      {required List<int> bytes,
      required int length,
      bool unmodifiable = true,
      String? objectName}) {
    if (bytes.length != length) {
      throw ADAPluginException("Invalid ${objectName ?? 'hash'} length.",
          details: {'expected': length, 'length': bytes.length});
    }
    return BytesUtils.toBytes(bytes, unmodifiable: unmodifiable);
  }

  static List<int> validateFixeHexByteslength({
    required String hexBytes,
    required int length,
    bool unmodifiable = true,
  }) {
    try {
      return validateFixedLengthBytes(
          bytes: BytesUtils.fromHexString(hexBytes),
          length: length,
          unmodifiable: unmodifiable);
    } on MessageException {
      rethrow;
    } catch (e) {
      throw ADAPluginException('Invalid hex bytes.',
          details: {'value': hexBytes});
    }
  }

  static List<T>? unmodifiable<T>(List<T>? list) {
    if (list == null) return null;
    return List<T>.unmodifiable(list);
  }
}
