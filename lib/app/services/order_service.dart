import '../core/gerencianet/pix/gerencianet_pix.dart';
import '../core/gerencianet/pix/models/qr_code_gerencianet_model.dart';
import '../repositories/order_repository.dart';
import '../repositories/product_repository.dart';
import '../repositories/user_repository.dart';
import '../view_models/order_view_model.dart';

class OrderService {
  final _repository = OrderRepository();
  final _userRepository = UserRepository();
  final _productRepository = ProductRepository();
  final _gerenciaNetPix = GerencianetPix();

  Future<QrCodeGerencianetModel> createOrder(OrderViewModel order) async {
    final orderId = await _repository.save(order);

    return await _createBilling(orderId, order);
  }

  Future<QrCodeGerencianetModel> _createBilling(
    int orderId,
    OrderViewModel order,
  ) async {
    final user = await _userRepository.findById(order.userId);

    var totalValue = 0.0;

    for (final item in order.items) {
      final product = await _productRepository.findById(item.productId);
      totalValue += product.price * item.amount;
    }

    final billing = await _gerenciaNetPix.generateBilling(
      value: totalValue,
      orderId: orderId,
      cpf: order.cpf?.replaceAll('.', '').replaceAll('-', ''),
      name: user.name,
    );

    await _repository.updateTransactionId(orderId, billing.transactionId);

    return await _gerenciaNetPix.getQrCode(billing.locationId, totalValue);
  }

  Future<void> confirmPayment(Iterable<String> transactions) async {
    for (final transaction in transactions) {
      await _repository.confirmPaymentByTransactionId(transaction);
    }
  }
}
