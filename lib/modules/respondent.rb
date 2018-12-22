module Respondent
  def greeting
    puts I18n.t(:greeting)
  end

  def for_choose_action
    puts I18n.t(:choose_action)
  end

  def in_process
    puts I18n.t(:in_process)
  end

  def wrong_input_action
    puts I18n.t(:wrong_input_action)
  end

  def select_difficulty
    puts I18n.t(:select_difficulty)
  end

  def show(argument)
    puts argument
  end
  # 
  # def incorrect_guess
  #   puts I18n.t(:when_incorrect_guess)
  # end

  def lose
    puts I18n.t(:when_lose)
  end

  def win
    puts I18n.t(:when_win)
  end

  def ask_name
    puts I18n.t(:ask_name)
  end

  def leave_output
    puts I18n.t(:leave)
  end
end
