require "json"
require "net/http"
require "uri"
require "fileutils"
require "rubygems/package"
require "zlib"
require "stringio"
require "tmpdir"

ROOT = File.expand_path(__dir__)

namespace :ocean do
  desc "Sincroniza os assets vendorizados com as versões do Ocean DS no package.json"
  task :update do
    pins = JSON.parse(File.read(File.join(ROOT, "package.json")))["dependencies"]
    core_version   = pins.fetch("@useblu/ocean-core")
    tokens_version = pins.fetch("@useblu/ocean-tokens")

    Dir.mktmpdir do |tmp|
      core   = fetch_npm_package("@useblu/ocean-core", core_version, tmp)
      tokens = fetch_npm_package("@useblu/ocean-tokens", tokens_version, tmp)

      # 1) CSS compilado (ocean-core)
      css_dir = File.join(ROOT, "app/assets/stylesheets/ocean_ds")
      FileUtils.mkdir_p(css_dir)
      cp(File.join(core, "ocean.css"),     File.join(css_dir, "ocean.css"))
      cp(File.join(core, "ocean.min.css"), File.join(css_dir, "ocean.min.css"))

      # 2) Tokens SCSS (ocean-tokens) -> partial importável
      cp(File.join(tokens, "web/tokens.scss"),
         File.join(ROOT, "vendor/assets/stylesheets/ocean_ds/_tokens.scss"))

      # 3) Fontes
      fonts_dest = File.join(ROOT, "app/assets/fonts/ocean_ds")
      FileUtils.rm_rf(fonts_dest)
      FileUtils.mkdir_p(fonts_dest)
      FileUtils.cp_r(Dir[File.join(tokens, "assets/fonts/*")], fonts_dest)

      # 4) @font-face -> _fonts.scss com caminho configurável
      generate_fonts_scss(
        File.join(tokens, "assets/css/fonts.css"),
        File.join(ROOT, "vendor/assets/stylesheets/ocean_ds/_fonts.scss")
      )

      # 5) Atualiza as versões registradas em version.rb
      update_version_constants(core_version, tokens_version)

      # 6) LICENSE upstream
      license = File.join(core, "LICENSE")
      cp(license, File.join(ROOT, "LICENSE")) if File.exist?(license)
    end

    puts "Ocean DS atualizado: core=#{core_version}, tokens=#{tokens_version}"
  end
end

def fetch_npm_package(name, version, tmp)
  meta_uri = URI("https://registry.npmjs.org/#{name}/#{version}")
  meta = JSON.parse(Net::HTTP.get(meta_uri))
  tarball = meta.fetch("dist").fetch("tarball")

  dest = File.join(tmp, name.gsub(%r{[@/]}, "_"))
  FileUtils.mkdir_p(dest)
  data = Net::HTTP.get(URI(tarball))

  Zlib::GzipReader.wrap(StringIO.new(data)) do |gz|
    Gem::Package::TarReader.new(gz) do |tar|
      tar.each do |entry|
        next unless entry.file?

        # tarballs npm prefixam tudo com "package/"
        rel = entry.full_name.sub(%r{\Apackage/}, "")
        out = File.join(dest, rel)
        FileUtils.mkdir_p(File.dirname(out))
        File.binwrite(out, entry.read)
      end
    end
  end
  dest
end

def generate_fonts_scss(src, dest)
  css = File.read(src)
  # ../fonts/Foo/Bar.woff2  ->  #{$ocean-ds-font-path}/Foo/Bar.woff2
  css = css.gsub(%r{\.\./fonts/}, '#{$ocean-ds-font-path}/')
  header = <<~HDR
    // Ocean DS — @font-face declarations
    // Gerado a partir de @useblu/ocean-tokens (assets/css/fonts.css).
    // NÃO edite à mão: rode `rake ocean:update` para regenerar.
    $ocean-ds-font-path: "ocean_ds" !default;

  HDR
  File.write(dest, header + css)
end

def update_version_constants(core_version, tokens_version)
  path = File.join(ROOT, "lib/ocean_ds/version.rb")
  src = File.read(path)
  src = src.sub(/OCEAN_CORE_VERSION = ".*?"/,   %(OCEAN_CORE_VERSION = "#{core_version}"))
  src = src.sub(/OCEAN_TOKENS_VERSION = ".*?"/, %(OCEAN_TOKENS_VERSION = "#{tokens_version}"))
  File.write(path, src)
end

def cp(src, dest)
  FileUtils.mkdir_p(File.dirname(dest))
  FileUtils.cp(src, dest)
end
