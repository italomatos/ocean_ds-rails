module OceanDS
  module Rails
    # Versão da gem (independente do upstream).
    VERSION = "0.1.0".freeze

    # Versões dos pacotes npm do Ocean DS vendorizados nesta release.
    # Mantidas em sincronia pela tarefa `rake ocean:update`.
    OCEAN_CORE_VERSION = "1.136.0".freeze
    OCEAN_TOKENS_VERSION = "3.8.1".freeze
  end
end
