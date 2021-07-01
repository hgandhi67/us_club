import 'package:auto_route/auto_route_annotations.dart';
import 'package:us_club/ui/screens.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    // initial route is named "/"
    MaterialRoute(page: LoginScreen),
    MaterialRoute(page: MainScreen),
    MaterialRoute(page: ProductDetails),
    MaterialRoute(page: OtpScreen),
    MaterialRoute(page: RegisterScreen),
    MaterialRoute(page: SubCategoriesScreen),
    MaterialRoute(page: SearchScreen),
    MaterialRoute(page: ImagePreviewScreen),
    MaterialRoute(page: UpdateProfilePage),
    MaterialRoute(page: CartPage),
    MaterialRoute(page: OrderDetailsScreen),
    MaterialRoute(page: ConfirmCartDetailsScreen),
  ],
)
class $Router {}
