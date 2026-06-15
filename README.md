# ocean_ds-rails

Empacota o [Ocean DS](https://github.com/ocean-ds) — o Design System open source da **BLU** —
para o **asset pipeline do Rails**. Vendoriza o CSS de componentes, os tokens SCSS (cores,
espaçamentos, tipografia) e as fontes oficiais, plugando tudo de forma idiomática tanto no
**Propshaft** (padrão no Rails 7/8) quanto no **Sprockets**.

Mesma ideia da gem `bootstrap`, mas para o Ocean DS.

| Conteúdo | Origem upstream |
|---|---|
| `ocean.css` / `ocean.min.css` (classes de componentes) | `@useblu/ocean-core` |
| `_tokens.scss` (variáveis `$color-*`, `$spacing-*`, `$font-*`, …) | `@useblu/ocean-tokens` |
| `_fonts.scss` + fontes `.woff2`/`.ttf` (Avenir, Nunito Sans) | `@useblu/ocean-tokens` |

## Instalação

```ruby
# Gemfile
gem "ocean_ds-rails"
```

```bash
bundle install
bin/rails g ocean_ds:install
```

O generator detecta o pipeline e injeta a linha de carregamento do CSS no lugar certo.

## Uso

### Componentes (CSS compilado)

Funciona **sem compilador Sass**.

- **Propshaft:** no layout
  ```erb
  <%= stylesheet_link_tag "ocean_ds/ocean" %>
  ```
- **Sprockets:** em `app/assets/stylesheets/application.css`
  ```css
  /*
   *= require ocean_ds/ocean
   */
  ```

Depois é só usar as classes do Ocean no HTML.

### Tokens SCSS + fontes (opcional)

Para usar as variáveis do Ocean nos seus próprios estilos e carregar as fontes, **requer um
compilador Sass** (`dartsass-rails`/`cssbundling` no Propshaft, `sass-rails` no Sprockets):

```scss
@import "ocean_ds/ocean_ds"; // = fontes (@font-face) + tokens (variáveis)

.minha-classe {
  color: $color-brand-primary-pure;
  padding: $spacing-inset-md;
  font-family: $font-family-base;
}
```

> Você também pode importar só os tokens (`@import "ocean_ds/tokens";`) ou só as fontes
> (`@import "ocean_ds/fonts";`).

#### Caminho das fontes

`_fonts.scss` usa a variável `$ocean-ds-font-path` (padrão `"ocean_ds"`), que resolve no Propshaft.
No Sprockets você pode sobrescrevê-la antes do `@import` se precisar:

```scss
$ocean-ds-font-path: asset-path("ocean_ds");
@import "ocean_ds/fonts";
```

## Manutenção / atualização do upstream

As versões vendorizadas ficam fixadas em `package.json`. Para atualizar:

1. Ajuste as versões em `package.json`.
2. Rode `rake ocean:update` — baixa os tarballs do npm, recopia CSS/tokens/fontes, regenera
   `_fonts.scss` e atualiza as constantes em `lib/ocean_ds/version.rb`.

## Versões vendorizadas

Veja `OCEAN_CORE_VERSION` e `OCEAN_TOKENS_VERSION` em `lib/ocean_ds/version.rb`.

## Licença

GPL-3.0, acompanhando o licenciamento do Ocean DS upstream. Veja `LICENSE`.
