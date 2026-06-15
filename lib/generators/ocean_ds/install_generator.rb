require "rails/generators/base"

module OceanDS
  module Generators
    # `rails g ocean_ds:install`
    #
    # Detecta o pipeline (Propshaft vs Sprockets) e injeta as linhas para
    # carregar o Ocean DS no manifesto de estilos do host.
    class InstallGenerator < ::Rails::Generators::Base
      # Sem isto, o Rails infere o namespace de `OceanDS` como "ocean_d_s"
      # (OceanDS.underscore == "ocean_d_s"), quebrando `rails g ocean_ds:install`.
      namespace "ocean_ds:install"

      source_root File.expand_path("templates", __dir__)

      def install
        if sprockets?
          install_sprockets
        else
          install_propshaft
        end
        print_instructions
      end

      private

      # Sinal confiável: o Sprockets só está carregado quando o app usa
      # sprockets-rails. Apps Propshaft não carregam ::Sprockets.
      def sprockets?
        defined?(::Sprockets::Rails) || defined?(::Sprockets)
      end

      def install_sprockets
        manifest = Dir.glob(
          File.join(destination_root, "app/assets/stylesheets/application.{css,scss,sass}")
        ).first

        if manifest && manifest.end_with?(".css")
          inject_into_file manifest, " *= require ocean_ds/ocean\n", before: %r{\*/}
        elsif manifest
          # application.scss/.sass: usa @import do índice (fontes + tokens) + componentes
          append_to_file manifest, %(\n@import "ocean_ds/ocean_ds";\n)
        else
          say "Não encontrei o manifesto app/assets/stylesheets/application.(css|scss).", :yellow
          say "Adicione manualmente: *= require ocean_ds/ocean", :yellow
        end
      end

      def install_propshaft
        layout = Dir.glob(File.join(destination_root, "app/views/layouts/application.html.{erb,haml,slim}")).first
        if layout
          inject_into_file layout,
            %(    <%= stylesheet_link_tag "ocean_ds/ocean", "data-turbo-track": "reload" %>\n),
            after: %r{<%= stylesheet_link_tag .*%>\n}
        else
          say "Não encontrei o layout application. Adicione manualmente:", :yellow
          say %(  <%= stylesheet_link_tag "ocean_ds/ocean" %>), :yellow
        end
      end

      def print_instructions
        say "\nOcean DS instalado.", :green
        say "Para usar os tokens SCSS (variáveis) e as fontes nos seus estilos, adicione no seu .scss:", :green
        say %(  @import "ocean_ds/ocean_ds"; // fontes + tokens), :green
        say "(requer um compilador Sass: dartsass-rails ou sass-rails)", :green
      end
    end
  end
end
