import 'package:get/get.dart';

class LoginProvider extends GetConnect {
  // post data login
  Future<Response> login(String username, String password) async {
    try {
      final body = '''
      <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
        <Body>
          <get_login xmlns="urn:ldap">
            <username>$username</username>
            <password>$password</password>
            <idapplication>hris</idapplication>
          </get_login>
        </Body>
      </Envelope>
      ''';

      var response = await post(
        "https://account.medionindonesia.com/index.php/ldap/index/wsdl?wsdl",
        body,
        contentType: 'text/xml',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
