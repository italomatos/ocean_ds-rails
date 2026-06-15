require "rails"

module OceanDS
  module Rails
    # Registra os assets do Ocean DS no pipeline do host, cobrindo tanto
    # Sprockets quanto Propshaft.
    #
    # - Propshaft: varre `app/assets/**` das engines automaticamente e reescreve
    #   as url() com digest. Os arquivos sob `vendor/assets/stylesheets` (tokens
    #   e fontes SCSS) são adicionados explicitamente ao load path.
    # - Sprockets: adiciona os diretórios a `config.assets.paths` e marca os CSS
    #   compilados para precompile.
    class Engine < ::Rails::Engine
      initializer "ocean_ds.assets" do |app|
        vendor_path = root.join("vendor", "assets", "stylesheets").to_s

        if app.config.respond_to?(:assets)
          # Sprockets (sprockets-rails)
          app.config.assets.paths << root.join("app", "assets", "stylesheets").to_s
          app.config.assets.paths << root.join("app", "assets", "fonts").to_s
          app.config.assets.paths << vendor_path
          app.config.assets.precompile += %w[
            ocean_ds/ocean.css
            ocean_ds/ocean.min.css
          ]
        end

        # Propshaft: garante que tokens/fontes SCSS fiquem visíveis para o
        # compilador Sass (dartsass-rails/cssbundling) via load_paths.
        if defined?(::Propshaft) && app.config.respond_to?(:assets) &&
           app.config.assets.respond_to?(:paths)
          app.config.assets.paths << vendor_path unless app.config.assets.paths.include?(vendor_path)
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
