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
    respondent.show_message(:greeting)
    loop do
      respondent.show_message(:choose_action)
      case input
      when USER_ACTIONS[:start] then return process
      when USER_ACTIONS[:rules] then rules.show_rules
      when USER_ACTIONS[:stats] then show_statistics
      else respondent.show_message(:wrong_input_action)
      end
    end
  end

  private

  def player
    @player ||= Player.new
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

  def statistic
    @statistic ||= Statistics.new
  end

  def process
    current_player = setup_player
    player_difficulty = setup_difficulty
    set_game_options(player_difficulty, current_player)
    play_game
  end

  def setup_player
    respondent.show_message(:ask_name)
    loop do
      player.assign_name(input.capitalize)
      next respondent.show(respondent.errors_store) unless player.valid?
      return player if player.valid?
    end
  end

  def setup_difficulty
    loop do
      respondent.show_message(:select_difficulty)
      user_difficulty_input = input
      return user_difficulty_input if game.valid_difficulties?(user_difficulty_input)
    end
  end

  def set_game_options(difficulty, player)
    game.game_options(user_difficulty: difficulty, player: player)
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
    game.remove_instance_helpers
    respondent.show_message(:when_lose)
    new_process
  end

  def win
    game.remove_instance_helpers
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

  def show_statistics
    respondent.show(winners_load)
  end

  def winners_load
    all_players = statistic.winners(load_db)
    table(all_players)
  end

  def table(rows)
    title = [
      I18n.t('table_fields.name'),
      I18n.t('table_fields.difficulty'),
      I18n.t('table_fields.attempts_total'),
      I18n.t('table_fields.attempts_used'),
      I18n.t('table_fields.hints_total'),
      I18n.t('table_fields.hints_used')
    ]
    Terminal::Table.new title: I18n.t('table_heder'), headings: title, rows: rows
  end
end
