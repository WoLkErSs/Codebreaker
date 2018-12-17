class Console
  include Database
  include Statistics
  include Validation
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

  def process
    choose_action
    start_game
    guess_code
    @game.winner ? winner(@game) : loser
  end

  def choose_action
    greeting
    loop do
      for_choose_action
      case input
      when AVAILABLE_ACTIONS[:start] then return call_registration
      when AVAILABLE_ACTIONS[:rules] then rules_call
      when AVAILABLE_ACTIONS[:stats] then statistics
      else wrong_input_action
      end
    end
  end

  private

  def start_game
    loop do
      select_difficulty
      user_difficulty_input = input
      @difficulty = user_difficulty_input.capitalize
      break if AVAILABLE_DIFFICULTY.include?(user_difficulty_input)
    end
    @game = Game.new(user_difficulty: @difficulty, player: @player)
  end

  def guess_code
    in_process
    loop do
      return unless @game.attempts_left.positive? && @game.winner.nil?

      what_guessed = @game.try(input)
      show(what_guessed) if what_guessed.is_a? Numeric
      show(what_guessed.join('')) if what_guessed.is_a? Array
      errors = @game.errors
      show(errors) if errors.any?
      @game.errors = []
      incorrect_guess if what_guessed.nil?
    end
  end

  def loser
    lose
    Console.new.process
  end

  def winner(player)
    win
    save_to_db(player) if input == AVAILABLE_ACTIONS[:save_player]
    Console.new.process
  end

  def call_registration
    ask_name
    loop do
      @player = Player.new(input.capitalize)
      errors = @player.errors_store
      show(errors) if errors.any?
      @player.errors_store = []
      return if !@player.name.nil?
    end
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
