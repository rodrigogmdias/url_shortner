# App Host

Aplicação Flutter principal que agrega rotas e widgets das features (`create`, `history`, `home`) e inicializa DI antes de rodar.

## Responsabilidades

- Inicializar dependências via `configureDependencies()`.
- Compor rotas de features em `routes.dart`.
- Rodar `MaterialApp.router` com `AppRouter` (pacote `router`).
- Servir como container para tema global / configurações futuras.

## Estrutura relevante

- `lib/main.dart` — entrypoint principal.
- `lib/app.dart` — widget raiz (`App`) com configuração de tema e router.
- `lib/routes.dart` — agrega rotas exportadas por features.
- `lib/dependencies/` — configuração de DI (`injectable.dart`, código gerado).

## Executar somente o app

Do diretório raiz (usando Melos):
```
melos exec -c 1 --scope=app -- flutter run -d <device_id>
```

Ou diretamente:
```
cd app
flutter run -d <device_id>
```

Listar devices:
```
flutter devices
```

## Geração de código (DI)

Recrie arquivos gerados ao alterar anotações:
```
melos run generate
```
Ou
```
dart run melos run generate
```

## Próximas melhorias

- Theming (cores, dark mode).
- Internacionalização.
- Logger / observabilidade.
- Integração real de rede (quando pacote `network` evoluir).

## Licença

Uso interno no workspace.

