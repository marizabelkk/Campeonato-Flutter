import 'package:http/http.dart' as http;

void validarResposta(http.Response response, String operacao) {
  if (response.statusCode < 200 || response.statusCode >= 300) {
    final detalhe = response.body.trim();
    throw Exception(
      '$operacao falhou (${response.statusCode})${detalhe.isEmpty ? '' : ': $detalhe'}',
    );
  }
}

String mensagemErro(Object erro) =>
    erro.toString().replaceFirst('Exception: ', '');
