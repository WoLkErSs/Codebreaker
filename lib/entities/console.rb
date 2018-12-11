class Console
  include Database
  include Statistics
  include Validation
  include Rules
  AVAILABLE_ACTIONS = {
                        start: 'start',
                        rules: 'rules',
                        stats: 'stats',
                        leave: 'exit',
                        save_player: 'y'}.freeze

  def initialize
    output.greeting
    @player = Player.new
    @game = Game.new
  end

  def process
    while @player.name.nil?
      output.for_choose_action
      choose_action(input?)
    end
    set_options_befor_start
    output.in_process
    guess_code
    @game.winner ? winner(@game) : loser
  end

  private

  def choose_action(action)
    case action
    when AVAILABLE_ACTIONS[:start] then call_registration
    when AVAILABLE_ACTIONS[:rules] then rules_call
    when AVAILABLE_ACTIONS[:stats] then statistics
    else output.wrong_input_action
    end
  end

  def set_options_befor_start
    while @game.hints_total.nil?
      output.select_difficulty
      @game.set_up_difficulty(input?.capitalize, @player.name)
    end
  end

  def guess_code
    while @game.attempts_left.positive? && @game.winner.nil?
      guess = input?
      if !validation(guess, Game::AMOUNT_DIGITS)
        what_guessed = @game.try(guess)
        output.show(what_guessed) if what_guessed.is_a? Numeric
        output.show(what_guessed.join('')) if what_guessed.is_a? Array
        errors = @game.errors
        output.show(errors) if errors.any?
        @game.errors = []
      else
        output.incorrect_guess
      end
    end
  end

  def loser
    output.lose
    @game = Game.new
    @player = Player.new
    process
  end

  def winner(player)
    output.win
    save_to_db(player) if input? == AVAILABLE_ACTIONS[:save_player]
    @game = Game.new
    @player = Player.new
    process
  end


  def validation(entity, length)
    validate_presence?(entity)
    !validate_length(entity,length)
  end

  def call_registration
    output.ask_name
    loop do
      break unless @player.name.nil?

      @player.assign_name(input?.capitalize)
      errors = @player.errors_store
      output.show(errors) if errors.any?
      @player.errors_store = []
    end
  end

  def output
    @output ||= Respondent.new
  end

  def input?
    input = gets.chomp.downcase
    if input == AVAILABLE_ACTIONS[:leave]
      output.leave
      exit
    else input
    end
  end

  def statistics
    output.show(winners(load_db))
  end
end
