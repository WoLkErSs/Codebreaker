require 'yaml'
require 'i18n'
require 'terminal-table'
require_relative '../modules/data_base.rb'
require_relative '../modules/statistics.rb'
require_relative '../modules/rules.rb'
require_relative '../modules/validator.rb'
require_relative '../entities/respondent.rb'
require_relative '../entities/player.rb'
require_relative '../entities/game.rb'
require_relative '../entities/console.rb'
I18n.load_path << Dir[File.expand_path('./lib/messages/en.yml')]
