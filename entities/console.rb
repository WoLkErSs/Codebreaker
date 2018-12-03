class Console
  include Registration
  include MyGame
  include Outputs
  include Database
  include Stats
  include Rules

  def initialize
    greeting
  end

  def benig_game
    while @hints.nil? && @attempts.nil?
      output_action
      action = gets.chomp.downcase
      hash_variebles = choose_action(action)
      assign_variables(hash_variebles) if hash_variebles
    end
    process = Player.new(name: @name, hints: @hints, attempts: @attempts, difficulty: @difficulty)
    winner(process) if process.winner
    looser(process) unless process.looser
  end

  def looser
    revoke
    benig_game
  end

  def revoke
    @hints = nil
    @attempts = nil
  end

  def winner(process)
    save_to_db(process) if save_player
    revoke
    benig_game
  end

  def can_save?(answer)
    case answer
    when 'yes' then true
    when 'y' then true
    when 'no' then false
    when 'n' then false
    else save_player
    end
  end

  def save_player
    ask_save
    answer = gets.chomp
    return can_save?(answer) if answer.is_a? String
    return false unless answer.is_a? String
  end

  def assign_variables(hash_variebles)
    @name = hash_variebles[:name]
    @hints = hash_variebles[:hints]
    @attempts = hash_variebles[:attempts]
    @difficulty = hash_variebles[:difficulty]
  end

  def choose_action(action)
    case action
    when 'start' then registration
    when 'rules' then rules
    when 'stats' then stats
    when 'exit' then leave
    else wrong_input_action
    end
  end

  def rules
    rules_call
  end

  def wrong_input_action
    output_wrong_input_action
  end

  def leave
    output_leave
    exit
  end

  def stats
    table = winners(load_db)
    winners_table(table)
  end
end
