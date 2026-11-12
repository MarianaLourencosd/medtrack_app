/// Configuração central dos links de compartilhamento do aplicativo.
///
/// Nesta etapa usamos apenas o custom scheme (`medtrack://`). Quando o site
/// for hospedado, basta trocar [linkPerfil] para retornar uma URL HTTPS e
/// manter o restante do aplicativo inalterado.
class ConfigLinks {
  const ConfigLinks._();

  static const String scheme = 'medtrack';
  static const String hostPerfil = 'perfil';

  /// Link compartilhável do perfil.
  static String linkPerfil(String uid) => '$scheme://$hostPerfil/$uid';
}
