module Outputs
  def ask_save
    puts 'Do you want to save your result?'
    puts 'Use one of this: \'yes\' or \'y\', \'no\' or \'n\''
  end

  def output_wrong_difficulty
    puts 'Choose one from difficulty list'
  end

  def output_ask_name
    puts 'Enter your name'
  end

  def output_action
    puts 'Choose actions: start, rules, stats or exit'
  end

  def output_difficulty
    puts 'Select difficulty of game: easy, hard, expert'
  end

  def winners_table(winners)
    puts winners.to_s
  end

  def greeting
    puts 'welcome to codebreaker'
  end

  def output_wrong_input_action
    puts 'You have passed unexpected command. Please choose one from listed commands'
  end

  def output_leave
    puts 'Goodbye'
  end

  def wrong_input_code
    puts 'You should enter one of the valid commands - one more time.'
  end

  def output_no_hints
    puts 'You have not hints'
  end

  def output_lose
    puts 'You lose'
  end

  def output_process
    puts 'Try to guess a secret code of Da`Vanya'
  end
end
