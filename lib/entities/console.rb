class Console
  include Database
  include Statistics
  include Rules
  AVAILABLE_ACTIONS = { start: 'start', rules: 'rules', stats: 'stats', leave: 'exit', save_player: 'y' }.freeze

  def initialize
    puts I18n.t(:greeting)
    @player = Player.new
    @game = Game.new
  end

  def process
    while @player.name.nil?
      puts I18n.t(:choose_action)
      choose_action(input?)
    end
    set_options_befor_start
    guess_code
    @game.winner ? winner(@game) : loser
  end

  def choose_action(action)
    case action
    when AVAILABLE_ACTIONS[:start] then call_registration
    when AVAILABLE_ACTIONS[:rules] then rules_call
    when AVAILABLE_ACTIONS[:stats] then statistics
    else puts I18n.t(:wrong_input_action)
    end

    def set_options_befor_start
      while @game.hints_total.nil?
        puts I18n.t(:select_difficulty)
        @game.set_up_difficulty(input?.capitalize, @player.name)
      end
    end

    def guess_code
      while @game.attempts_left.positive? && @game.winner.nil?
        puts @game.secret_code.inspect
        puts I18n.t(:in_process)
        what_guessed = @game.try(input?)
        puts what_guessed if what_guessed.is_a? Numeric
        puts what_guessed.join('') if what_guessed.is_a? Array
        puts @game.errors unless what_guessed
        @game.errors = []
      end
    end

    def loser
      puts I18n.t(:when_lose)
      @game = Game.new
      @player = Player.new
      process
    end
  end

  def winner(player)
    puts I18n.t(:when_win) + "'#{AVAILABLE_ACTIONS[:save_player]}'"
    save_to_db(player) if input? == AVAILABLE_ACTIONS[:save_player]
    @game = Game.new
    @player = Player.new
    process
  end

  private

  def call_registration
    loop do
      print @player.errors_store[:when_wrong_name]
      break if !@player.name.nil?
      puts I18n.t(:ask_name)
      @player.assign_name(input?.capitalize)
    end
  end

  def input?
    input = gets.chomp.downcase
    if input == AVAILABLE_ACTIONS[:leave]
      puts I18n.t(:leave)
      exit
   else input
   end
  end

  def statistics
    table = winners(load_db)
    puts table.to_s
  end
end
