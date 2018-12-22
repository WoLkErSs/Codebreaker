class ProcessHelper
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

  attr_reader :setup_player, :setup_difficulty

  def initialize(player: Player.new)
    @player = player
  end

  def setup_player
    ask_name
    loop do
      @player.assign_name(input.capitalize)
      show(@player.errors_store) if @player.errors_store.any?
      return @player if !@player.name.nil?
    end
  end

  def setup_difficulty
    loop do
      select_difficulty
      user_difficulty_input = input
      return user_difficulty_input if AVAILABLE_DIFFICULTY.include?(user_difficulty_input)
    end
  end

  private

  def input
    input = gets.chomp.downcase
    leave if input == AVAILABLE_ACTIONS[:leave]
    input
  end

  def leave
    leave_output
    exit
  end
end
