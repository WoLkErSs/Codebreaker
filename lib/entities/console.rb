require 'pry'
class Console
  include Database
  include Statistics
  include Rules
  include Respondent

  AVAILABLE_ACTIONS = {
                        start: 'start',
                        rules: 'rules',
                        stats: 'stats',
                        leave: 'exit',
                        save_player: 'y'}.freeze
  AVAILABLE_DIFFICULTY = [
                          'easy',
                          'hard',
                          'expert'].freeze

  def initialize(process_helper: ProcessHelper.new, set_game: Game.new)
    @process_helpers = process_helper
    @game = set_game
  end

  def choose_action
    greeting
    loop do
      for_choose_action
      case input
      when AVAILABLE_ACTIONS[:start] then return process
      when AVAILABLE_ACTIONS[:rules] then show_rules
      when AVAILABLE_ACTIONS[:stats] then statistics
      else wrong_input_action
      end
    end
  end

  private

  def process
    @player = @process_helpers.setup_player
    @difficulty = @process_helpers.setup_difficulty
    set_game_options(@difficulty, @player)
    play_game
  end

  def set_game_options(difficulty, player_object)
    @game.game_options(user_difficulty: difficulty, player: player_object)
  end

  def play_game
    in_process
    loop do
      what_guessed = @game.try(input)
      show(what_guessed.join('')) if what_guessed.is_a? Array
      show(@game.errors) if @game.errors.any?
      break unless validate_game_state
    end
    result_decision
  end

  def validate_game_state
    @game.attempts_left.positive? && @game.winner.nil?
  end

  def result_decision
    @game.winner ? winner(@game) : loser
  end

  def loser
    lose
    new_process
  end

  def winner(player)
    win
    save_to_db(player) if input == AVAILABLE_ACTIONS[:save_player]
    new_process
  end

  def new_process
    Console.new.choose_action
  end

  def input
    input = gets.chomp.downcase
    leave if input == AVAILABLE_ACTIONS[:leave]
    input
  end

  def leave
    leave_output
    exit
  end

  def statistics
    show(winners(load_db))
  end
end
