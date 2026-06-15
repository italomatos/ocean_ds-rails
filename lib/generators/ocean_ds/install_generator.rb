require "rails/generators/base"

module OceanDS
  module Generators
    # `rails g ocean_ds:install`
    #
    # Detecta o pipeline (Propshaft vs Sprockets) e injeta as linhas para
    # carregar o Ocean DS no manifesto de estilos do host.
    class InstallGenerator < ::Rails::Generators::Base
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

      def sprockets?
        defined?(::Sprockets::Rails) &&
          File.exist?(File.join(destination_root, "app/assets/config/manifest.js")) ||
          Dir.glob(File.join(destination_root, "app/assets/stylesheets/application.{css,scss,sass}")).any? { |f| f.end_with?(".css") && File.read(f).include?("require_tree") }
      end

      def install_sprockets
        manifest = File.join(destination_root, "app/assets/stylesheets/application.css")
        if File.exist?(manifest)
          inject_into_file manifest, " *= require ocean_ds/ocean\n", before: %r{\*/}
        else
          say "Não encontrei app/assets/stylesheets/application.css.", :yellow
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
