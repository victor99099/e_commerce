import 'package:googleapis_auth/auth_io.dart';

class GetServiceKey {
  Future<String> getServerKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "e-commerece-f7d89",
          "private_key_id": "e82df74f98d96fe6c70513996e0724debdf8ddeb",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCTkOZ5bq1NeDCZ\nFOwa5RNPxEqiBlAnD5ecvfQzcy7SOzh2GzX8tVlvjh/JQki/Ys3xdBEwdfiF4z4k\nq3SMPDGal4mn+rh14JpI0pkOxBoBhlo5OFVUzsHyPjXlCXaGJzzeoEpdb0uekxqU\nYEWqygFcmyr1CPXdv80lKjfaFpmrLxRj/+1YozEGEwhTWBxEPIL4CUm7YHOIHO8o\nhjwdqBXJ+4+jsr4vA0Gbq4gkPlmWDak4XOp6vt5FSST3LeId5w7YH22l/SmC0vGb\nrQZsq5A+T0uAEgpHBX7VcM/ztRL8P4c0KomLnd3NKEgR87tQ8JtMDebC5la+LnFl\nyg60WItdAgMBAAECggEAAaFZFbE5Ovy01yQdIesQ9y9m4JzFCuwZJKqpxX/gGbav\n+iqXQncY+GqRx8vuXze3ZK1D5ARm97ezao5coTtTAvfY4seRwWYIIpc51XXUCB+M\nKOTwmO6gf2+YC28Y1GtSwVTjaSsL51MV/UEwfoOB8TXfHEFxyWUCkY8+Rw2yzJUa\nPd39cC7YUF5ujyJYE/DKOo9VBNUDphX3g8Voz7BmM+4viiY97QRPCtKNwsyoP1GR\nvvAlPki0WnA4aV+1+gxJmiLm6jgMoWYzyFI1wSISaXccJeoaYP4HL8/0ZVj69Ky/\n8G84ghFakDiC0dGtdGCTMwgRbq9KqV6GOxWWKgeIIwKBgQDHGLyoSmfqD/o8i7eX\n70YmEHl/fOc6wR52OumSmJXLG2DJ4q6+QJohKwllCl0vlUDo9YoDZPDxTyp8pCFk\nGa0E0rgqZXGpJwpOCzvTjHaxM5WVHAGPUN/xD9WrhqrDNR7Bl9bXBpQzaXaE05oN\n8tbkE5GKG0L8BkbthmdnJLPppwKBgQC9vdVaa8scz29XXA5/fkt6rnYdv10JbwHd\n0zQCnwgrqb23XOPGNQTkEt3focmNY8h5OahTunKDanqRvqtG0H/jSNEd3zHgUz0+\nGoEJJoj4hYChA7iAX3NcBXt7jsqhsYXLi2ShXRLe/6RJ+vW+IZfkK2Q2uJztLtQO\nhJ3WbX07WwKBgQC55+xJTGjpkw+7N08wbLlY06tPksarAya5iVsOirHcXG0tNiCq\n/9GrxO7ZzSqkQr7AiH3dm4SsHprylaOkP6FiToyu8diG9TBXHYA4kgFGh39WIzeF\npiPliT6gEngjHNfiNzDhyX/a3dBQSPGhsq5be7Y7eic7A3V5VzX4hroEIwKBgANr\nUVXwzVc2kb4URZqcjwWl8TD2CtopqvHxZWWKsh3/UBDm1p/ywqTNhjwKcVRf8PPm\nSxc/K+McXxsTQYjkJvnUjRgptn9hYKAm4B5nGF7KIRhFteRyU+TboG8IkrQ5O70A\nRQ73W2izWKWQpS8I8fDFq2elCgboKiAc2a9Mh84zAoGBALXd2RTp1AVxJ4jbO9TD\nOUfEE1X/+EWgllDla41Gb7XMH7DlejPClv2Sr4ZJfKMKIfXNjldO6yyrIZKOKxHf\nuDC8toLw9o37SxIvGRUf5SC+7efLSIlk+821103uP8zHdlU3PzO8h4YGFxhOEMLV\nNxKofDdJ3yZ07Eq3kf5XUwjd\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-70z0o@e-commerece-f7d89.iam.gserviceaccount.com",
          "client_id": "116509950805470798947",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-70z0o%40e-commerece-f7d89.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        scopes);

    final accessServerKey = client.credentials.accessToken.data;

    return accessServerKey;
  }
}
