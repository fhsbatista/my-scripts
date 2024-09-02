#!/usr/bin/env ruby

require 'fileutils'

# Verifica se o nome da gem foi fornecido
if ARGV.length != 1
  puts "Uso: #{$PROGRAM_NAME} NOME_DA_GEM"
  exit 1
end

gem_name = ARGV[0]
gemfile = 'Gemfile'
local_path = "../#{gem_name}"

# Verifica se o Gemfile existe
unless File.exist?(gemfile)
  puts "Arquivo Gemfile não encontrado!"
  exit 1
end

# Cria um backup do Gemfile
FileUtils.cp(gemfile, "#{gemfile}.bak")

# Lê o conteúdo do Gemfile
content = File.read(gemfile)

pattern = /gem '#{gem_name}', git: 'git@bitbucket.org:(.*?)\.git'/
lines = content.lines.map do |line|
  if line.match(pattern)
    repo_name = line.match(pattern)[1].split('/').last
    "gem '#{gem_name}', path: '../#{repo_name}'\n"
  else
    line
  end
end

File.open(gemfile, 'w') do |file|
  file.write(lines.join)
end

puts "Gemfile atualizado com sucesso!"