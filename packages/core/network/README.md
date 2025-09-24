# network

Placeholder atual para a futura camada de rede (APIs do encurtador). No momento contém apenas código gerado de template.

## Objetivos (planejado)

- Configurar cliente HTTP (provavelmente `dio`).
- Interceptores (logging, headers, auth futura se necessário).
- Serialização (possível adoção de `json_serializable`).
- Abstrações de repositórios compartilhadas entre features.

## Estado Atual

Ainda não implementado. `Calculator` é apenas artefato padrão de criação de pacote.

## Roadmap sugerido

1. Adicionar dependência `dio`.
2. Criar `NetworkClient` central com configuração baseUrl.
3. Implementar interceptores (log e timeout).
4. Adaptar features (`create`, `history`) para consumir endpoints reais.
5. Cobrir com testes de integração usando mocks (`http_mock_adapter` ou similar).

## Exemplo Futuro (esboço)

```dart
final dio = Dio(BaseOptions(baseUrl: env.apiBaseUrl));
dio.interceptors.add(LogInterceptor());

@singleton
class ShortUrlApi {
	ShortUrlApi(this._dio);
	final Dio _dio;

	Future<ShortUrlDto> create(String url) async {
		final res = await _dio.post('/shorten', data: {'url': url});
		return ShortUrlDto.fromJson(res.data as Map<String, dynamic>);
	}
}
```

## Desenvolvimento

Formatar / fixes:
```
dart format .
dart fix --apply
```

## Licença

Uso interno no workspace.

