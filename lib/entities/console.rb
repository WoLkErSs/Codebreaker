class Console
  include Database
  USER_ACTIONS = {
    start: 'start',
    rules: 'rules',
    stats: 'stats',
    leave: 'exit'
  }.freeze
  ACTIONS_FOR_DATABASE = {
    save_player: 'y'
  }.freeze

  def choose_action
    loop do
      respondent.show_message(:choose_action)
      case input
      when USER_ACTIONS[:start] then return process
      when USER_ACTIONS[:rules] then rules.show_rules
      when USER_ACTIONS[:stats] then statistics
      else respondent.show_message(:wrong_input_action)
      end
    end
  end

  private

  def process_helper
    @process_helper ||= ProcessHelper.new
  end

  def rules
    @rules ||= Rules.new
  end

  def game
    @game ||= Game.new
  end

  def respondent
    @respondent ||= Respondent.new
  end

  def process
    @player = process_helper.setup_player
    @difficulty = process_helper.setup_difficulty
    set_game_options
    play_game
  end

  def set_game_options
    game.game_options(user_difficulty: @difficulty, player: @player)
  end

  def play_game
    respondent.show_message(:in_process)
    while game_state_valid?
      what_guessed = game.attempt(input)
      respondent.show(what_guessed) if what_guessed
      respondent.show(game.errors) unless game.errors.empty?
    end
    result_decision
  end

  def game_state_valid?
    game.attempts_left.positive? && !game.winner
  end

  def result_decision
    game.winner ? win : lose
  end

  def lose
    respondent.show_message(:when_lose)
    new_process
  end

  def win
    respondent.show_message(:when_win)
    save_to_db(game) if input == ACTIONS_FOR_DATABASE[:save_player]
    new_process
  end

  def new_process
    choose_action
  end

  def input
    input = gets.chomp.downcase
    input == USER_ACTIONS[:leave] ? leave : input
  end

  def leave
    respondent.show_message(:leave)
    exit
  end

  def statistics
    respondent.show(winners_load)
  end

  def winners_load
    statistic.winners(load_db)
  end

  def statistic
    @statistic ||= Statistics.new
  end
end
