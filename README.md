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

### Componentes + fontes (CSS compilado)

Funciona **sem compilador Sass**. São dois stylesheets: `ocean_ds/fonts` (as declarações
`@font-face` de Avenir e Nunito Sans) e `ocean_ds/ocean` (as classes de componente). O
`ocean.css` **não** inclui `@font-face` — ele só pede as famílias `"Avenir"`/`"Nunito Sans"`,
então **sem o `ocean_ds/fonts` o navegador cai numa fonte de fallback**.

- **Propshaft:** no layout (o generator já injeta esta linha)
  ```erb
  <%= stylesheet_link_tag "ocean_ds/fonts", "ocean_ds/ocean" %>
  ```
- **Sprockets:** em `app/assets/stylesheets/application.css`
  ```css
  /*
   *= require ocean_ds/fonts
   *= require ocean_ds/ocean
   */
  ```

Depois é só usar as classes do Ocean no HTML.

### Tokens SCSS (opcional — requer Sass)

Para usar as **variáveis** do Ocean nos seus próprios estilos você precisa de um compilador Sass
(`dartsass-rails`/`cssbundling` no Propshaft, `sass-rails` no Sprockets):

```scss
@import "ocean_ds/tokens";

.minha-classe {
  color: $color-brand-primary-pure;
  padding: $spacing-inset-md;
  font-family: $font-family-base;
}
```

> As fontes **não** dependem de Sass: já são carregadas pelo `ocean_ds/fonts` (CSS puro). Se você
> usa Sass e prefere o partial, existe também `@import "ocean_ds/fonts";` (`_fonts.scss`), que usa a
> variável `$ocean-ds-font-path` (padrão `"ocean_ds"`).

## Manutenção / atualização do upstream

As versões vendorizadas ficam fixadas em `package.json`. Para atualizar:

1. Ajuste as versões em `package.json`.
2. Rode `rake ocean:update` — baixa os tarballs do npm, recopia CSS/tokens/fontes, regenera
   `_fonts.scss` e atualiza as constantes em `lib/ocean_ds/version.rb`.

## Versões vendorizadas

Veja `OCEAN_CORE_VERSION` e `OCEAN_TOKENS_VERSION` em `lib/ocean_ds/version.rb`.

## Licença

GPL-3.0, acompanhando o licenciamento do Ocean DS upstream. Veja `LICENSE`.
