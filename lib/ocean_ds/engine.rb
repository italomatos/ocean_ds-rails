require "rails"

module OceanDS
  module Rails
    # Registra os assets do Ocean DS no pipeline do host, cobrindo tanto
    # Propshaft quanto Sprockets — ambos leem `config.assets.paths`.
    #
    # - Propshaft: serve tudo que está no load path e reescreve as url() do CSS
    #   com digest (o `fonts.css` referencia as fontes por caminho relativo).
    # - Sprockets: além dos paths, marca os CSS compilados para precompile.
    class Engine < ::Rails::Engine
      initializer "ocean_ds.assets" do |app|
        next unless app.config.respond_to?(:assets) && app.config.assets.respond_to?(:paths)

        paths = [
          root.join("app", "assets", "stylesheets").to_s,
          root.join("app", "assets", "fonts").to_s,
          root.join("vendor", "assets", "stylesheets").to_s
        ]
        # Vale para Propshaft e Sprockets: ambos leem config.assets.paths.
        paths.each { |p| app.config.assets.paths << p unless app.config.assets.paths.include?(p) }

        # precompile só existe/importa no Sprockets. No Propshaft é nil
        # (OrderedOptions) e tudo no load path já é servido — então só mexe
        # quando for de fato um Array, evitando NoMethodError no boot.
        if app.config.assets.precompile.is_a?(Array)
          app.config.assets.precompile += %w[
            ocean_ds/ocean.css
            ocean_ds/ocean.min.css
            ocean_ds/fonts.css
          ]
        end
      end

      # Expõe o diretório de tokens/fontes SCSS para dartsass-rails, que usa
      # seu próprio load_path independente do Sprockets.
      initializer "ocean_ds.dartsass" do |app|
        if defined?(::Dartsass)
          load_path = root.join("vendor", "assets", "stylesheets")
          if app.config.respond_to?(:dartsass) &&
             app.config.dartsass.respond_to?(:load_paths)
            app.config.dartsass.load_paths << load_path.to_s
          end
        end
      end
    end
  end
end
