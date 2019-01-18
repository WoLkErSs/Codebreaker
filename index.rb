require_relative './lib/autoload/autoload.rb'
Respondent.new.show_message(:greeting)
Console.new.choose_action
