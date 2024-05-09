// import 'dart:convert';
//
// import 'package:ba3_business_solutions/model/products_model.dart';
// import 'package:realm_dart/realm.dart';
//
// import '../Const/const.dart';
//
// abstract class RealmDataBase {
//   static late Realm  realm ;
//   static late App app ;
//   static late User user;
//   static init() async {
//     app =App(AppConfiguration("ba3_business_solutions-ecevvce",baseUrl: Uri.parse("https://services.cloud.mongodb.com")),);
//     user = await app.logIn(Credentials.anonymous());
//     realm = Realm(Configuration.flexibleSync(user, [ProdRecord.schema,Products.schema]));
//     realm.subscriptions.update((mutableSubscriptions) {
//       mutableSubscriptions.clear();
//       mutableSubscriptions.add(realm.all<Products>(), name: Const.productsAllSubscription);
//     });
//     // realm.write<Products>(() => realm.add<Products>(Products(ObjectId(),prodName: "hello")));
//   }
// }