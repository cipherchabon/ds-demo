## Mocking y Testing

Cuando tus widgets dependen de servicios externos, providers, o estado global, necesitas mockear estas dependencias para poder catalogarlos en Widgetbook.

### Estrategia 1: Extracción de Propiedades

La forma más simple es extraer las dependencias como parámetros del widget.

#### Antes (Con dependencia de Provider)

```dart
// widget acoplado a Provider
class UserProfileTile extends StatelessWidget {
  const UserProfileTile({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependencia implícita de UserProvider
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.currentUser;

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.avatarUrl),
          ),
          title: Text(user.name),
          subtitle: Text(user.email),
          trailing: Icon(
            user.isVerified ? Icons.verified : Icons.person,
          ),
        );
      },
    );
  }
}
```

**Problema**: No puedes usar este widget en Widgetbook sin un `UserProvider` real.

#### Después (Con extracción de propiedades)

```dart
// models/user.dart
class User {
  final String name;
  final String email;
  final String avatarUrl;
  final bool isVerified;

  const User({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.isVerified,
  });
}

// widgets/user_profile_tile.dart
class UserProfileTile extends StatelessWidget {
  const UserProfileTile({
    super.key,
    required this.user,  // Dependencia explícita
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.avatarUrl),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: Icon(
        user.isVerified ? Icons.verified : Icons.person,
      ),
    );
  }
}

// En tu app, usarías:
// UserProfileTile(user: context.read<UserProvider>().currentUser)
```

#### Use-case en Widgetbook

```dart
@widgetbook.UseCase(
  name: 'Verified User',
  type: UserProfileTile,
  path: '[Widgets]/User',
)
Widget buildVerifiedUserTile(BuildContext context) {
  return UserProfileTile(
    user: User(
      name: context.knobs.string(label: 'Name', initialValue: 'Jane Doe'),
      email: context.knobs.string(label: 'Email', initialValue: 'jane@example.com'),
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      isVerified: true,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Unverified User',
  type: UserProfileTile,
  path: '[Widgets]/User',
)
Widget buildUnverifiedUserTile(BuildContext context) {
  return UserProfileTile(
    user: User(
      name: 'John Smith',
      email: 'john@example.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=8',
      isVerified: false,
    ),
  );
}
```

### Estrategia 2: Mocking con Mocktail

Cuando no puedes o no quieres extraer propiedades, puedes mockear dependencias usando **mocktail**.

#### Instalación

En `widgetbook/pubspec.yaml` (como **dependency**, no dev_dependency):

```yaml
dependencies:
  # ...
  mocktail: ^1.0.0
  provider: ^6.0.0 # Si usas Provider
```

#### Ejemplo 1: Mocking de un Service

```dart
// services/api_service.dart en tu app
abstract class ApiService {
  Future<List<Product>> fetchProducts();
  Future<Product> getProductById(String id);
}

// widgets/product_list.dart en tu app
class ProductListWidget extends StatelessWidget {
  const ProductListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = context.read<ApiService>();

    return FutureBuilder<List<Product>>(
      future: apiService.fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error);
        }

        final products = snapshot.data ?? [];
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) => ProductTile(products[index]),
        );
      },
    );
  }
}
```

#### Mock en Widgetbook

```dart
// widgetbook/lib/products/product_list_usecases.dart
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:your_app/services/api_service.dart';
import 'package:your_app/models/product.dart';
import 'package:your_app/widgets/product_list.dart';

// 1. Crear mock
class MockApiService extends Mock implements ApiService {}

// 2. Use-case con datos de éxito
@widgetbook.UseCase(
  name: 'Success State',
  type: ProductListWidget,
  path: '[Widgets]/Products',
)
Widget buildProductListSuccess(BuildContext context) {
  // Crear instancia del mock
  final mockApiService = MockApiService();

  // Configurar comportamiento
  when(() => mockApiService.fetchProducts()).thenAnswer(
    (_) async => [
      Product(id: '1', name: 'iPhone 15', price: 999.99),
      Product(id: '2', name: 'MacBook Pro', price: 2499.99),
      Product(id: '3', name: 'AirPods Pro', price: 249.99),
    ],
  );

  // Proveer el mock
  return Provider<ApiService>.value(
    value: mockApiService,
    child: ProductListWidget(),
  );
}

// 3. Use-case con estado de error
@widgetbook.UseCase(
  name: 'Error State',
  type: ProductListWidget,
  path: '[Widgets]/Products',
)
Widget buildProductListError(BuildContext context) {
  final mockApiService = MockApiService();

  when(() => mockApiService.fetchProducts()).thenThrow(
    Exception('Failed to fetch products'),
  );

  return Provider<ApiService>.value(
    value: mockApiService,
    child: ProductListWidget(),
  );
}

// 4. Use-case con lista vacía
@widgetbook.UseCase(
  name: 'Empty State',
  type: ProductListWidget,
  path: '[Widgets]/Products',
)
Widget buildProductListEmpty(BuildContext context) {
  final mockApiService = MockApiService();

  when(() => mockApiService.fetchProducts()).thenAnswer(
    (_) async => [],
  );

  return Provider<ApiService>.value(
    value: mockApiService,
    child: ProductListWidget(),
  );
}
```

#### Ejemplo 2: Mocking de ChangeNotifier

```dart
// providers/cart_provider.dart en tu app
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemCount => _items.length;
  double get total => _items.fold(0, (sum, item) => sum + item.price);

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}

// widgets/cart_badge.dart
class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Badge(
          label: Text('${cart.itemCount}'),
          child: Icon(Icons.shopping_cart),
        );
      },
    );
  }
}
```

#### Mock en Widgetbook

```dart
// widgetbook/lib/cart/cart_badge_usecases.dart
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:your_app/providers/cart_provider.dart';
import 'package:your_app/widgets/cart_badge.dart';

class MockCartProvider extends Mock implements CartProvider {}

@widgetbook.UseCase(
  name: 'Empty Cart',
  type: CartBadge,
  path: '[Widgets]/Cart',
)
Widget buildEmptyCartBadge(BuildContext context) {
  final mockCart = MockCartProvider();

  when(() => mockCart.itemCount).thenReturn(0);
  when(() => mockCart.items).thenReturn([]);

  return ChangeNotifierProvider<CartProvider>.value(
    value: mockCart,
    child: CartBadge(),
  );
}

@widgetbook.UseCase(
  name: 'With Items',
  type: CartBadge,
  path: '[Widgets]/Cart',
)
Widget buildCartBadgeWithItems(BuildContext context) {
  final mockCart = MockCartProvider();

  final itemCount = context.knobs.int.slider(
    label: 'Item Count',
    initialValue: 3,
    min: 1,
    max: 99,
  );

  when(() => mockCart.itemCount).thenReturn(itemCount);

  return ChangeNotifierProvider<CartProvider>.value(
    value: mockCart,
    child: CartBadge(),
  );
}
```

#### Ejemplo 3: Mocking de Múltiples Providers

```dart
// widgetbook/lib/checkout/checkout_screen_usecases.dart
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}
class MockCartProvider extends Mock implements CartProvider {}
class MockPaymentService extends Mock implements PaymentService {}

@widgetbook.UseCase(
  name: 'Authenticated with Items',
  type: CheckoutScreen,
  path: '[Screens]/Checkout',
)
Widget buildCheckoutScreen(BuildContext context) {
  // Setup mocks
  final mockAuth = MockAuthService();
  final mockCart = MockCartProvider();
  final mockPayment = MockPaymentService();

  // Configure auth
  when(() => mockAuth.isAuthenticated).thenReturn(true);
  when(() => mockAuth.currentUser).thenReturn(
    User(id: '1', name: 'John Doe', email: 'john@example.com'),
  );

  // Configure cart
  when(() => mockCart.items).thenReturn([
    CartItem(id: '1', name: 'Product 1', price: 29.99, quantity: 2),
    CartItem(id: '2', name: 'Product 2', price: 49.99, quantity: 1),
  ]);
  when(() => mockCart.total).thenReturn(109.97);

  // Configure payment
  when(() => mockPayment.processPayment(any())).thenAnswer(
    (_) async => PaymentResult(success: true, transactionId: 'txn_123'),
  );

  // Provide all mocks
  return MultiProvider(
    providers: [
      Provider<AuthService>.value(value: mockAuth),
      ChangeNotifierProvider<CartProvider>.value(value: mockCart),
      Provider<PaymentService>.value(value: mockPayment),
    ],
    child: CheckoutScreen(),
  );
}
```

### Estrategia 3: Test Fixtures / Factories

Para datos complejos, crea factories o fixtures reutilizables:

```dart
// widgetbook/lib/fixtures/user_fixtures.dart
class UserFixtures {
  static User verifiedUser({
    String? name,
    String? email,
  }) {
    return User(
      id: '1',
      name: name ?? 'Jane Doe',
      email: email ?? 'jane@example.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      isVerified: true,
      role: UserRole.premium,
      joinedAt: DateTime(2023, 1, 15),
    );
  }

  static User unverifiedUser({
    String? name,
    String? email,
  }) {
    return User(
      id: '2',
      name: name ?? 'John Smith',
      email: email ?? 'john@example.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=8',
      isVerified: false,
      role: UserRole.free,
      joinedAt: DateTime.now(),
    );
  }

  static User adminUser() {
    return User(
      id: '99',
      name: 'Admin User',
      email: 'admin@company.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      isVerified: true,
      role: UserRole.admin,
      joinedAt: DateTime(2020, 1, 1),
    );
  }
}

// widgetbook/lib/fixtures/product_fixtures.dart
class ProductFixtures {
  static Product electronics() {
    return Product(
      id: '1',
      name: 'iPhone 15 Pro',
      description: 'Latest iPhone with A17 chip',
      price: 999.99,
      category: 'Electronics',
      imageUrl: 'https://picsum.photos/200/200?random=1',
      rating: 4.8,
      reviewCount: 1234,
      inStock: true,
    );
  }

  static Product outOfStock() {
    return Product(
      id: '2',
      name: 'PlayStation 5',
      description: 'Next-gen gaming console',
      price: 499.99,
      category: 'Gaming',
      imageUrl: 'https://picsum.photos/200/200?random=2',
      rating: 4.9,
      reviewCount: 5678,
      inStock: false,  // Out of stock state
    );
  }

  static List<Product> productList({int count = 5}) {
    return List.generate(
      count,
      (index) => Product(
        id: '$index',
        name: 'Product ${index + 1}',
        description: 'Description for product ${index + 1}',
        price: 10.0 + (index * 15.0),
        category: ['Electronics', 'Clothing', 'Home'][index % 3],
        imageUrl: 'https://picsum.photos/200/200?random=$index',
        rating: 3.5 + (index % 3) * 0.5,
        reviewCount: (index + 1) * 10,
        inStock: index % 4 != 0,  // Algunos out of stock
      ),
    );
  }
}
```

#### Uso de Fixtures en Use-cases

```dart
@widgetbook.UseCase(
  name: 'Verified User',
  type: UserCard,
  path: '[Cards]/User',
)
Widget buildVerifiedUserCard(BuildContext context) {
  return UserCard(
    user: UserFixtures.verifiedUser(
      name: context.knobs.string(label: 'Name', initialValue: 'Jane Doe'),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Product List',
  type: ProductGrid,
  path: '[Grids]/Products',
)
Widget buildProductGrid(BuildContext context) {
  final count = context.knobs.int.slider(
    label: 'Product Count',
    initialValue: 6,
    min: 1,
    max: 20,
  );

  return ProductGrid(
    products: ProductFixtures.productList(count: count),
  );
}

@widgetbook.UseCase(
  name: 'Out of Stock',
  type: ProductCard,
  path: '[Cards]/Product',
)
Widget buildOutOfStockProduct(BuildContext context) {
  return ProductCard(
    product: ProductFixtures.outOfStock(),
  );
}
```

---
