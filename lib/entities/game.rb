class Game
  include Validation

  AMOUNT_DIGITS = 4
  RANGE_DIGITS = 1..6
  DIFFICULTIES = {
    easy: { attempts: 15, hints: 4, difficulty: 'easy' },
    hard: { attempts: 10, hints: 2, difficulty: 'hard' },
    expert: { attempts: 5, hints: 1, difficulty: 'expert' }
  }.freeze
  RANGE_OF_DIGITS = 0..4.freeze
  GUESS_CODE = { hint: 'hint', leave: 'exit' }.freeze

  attr_reader :name, :hints_total, :attempts_total, :hints_used, :attempts_used, :difficulty, :winner, :attempts_left
  attr_accessor :errors

  def game_options(user_difficulty:, player:)
<<<<<<< HEAD
=======
    @hints_array = nil
>>>>>>> 52f842a77abe6c6fd68aec9c975658ff2bdd5765
    @got_hints = ''
    @hints_used = 0
    @attempts_used = 0
    @winner = nil
    @name = player.name
    assign_difficulty(DIFFICULTIES[user_difficulty.downcase.to_sym])
  end

  def attempt(input)
    @errors = []
    return use_hint if hint?(input)

    converted = convert_to_array(input)
    return guessing(converted) if valid_input?(input, AMOUNT_DIGITS)
    miss_input && return
  end

  def miss_input
    @errors = []
    @errors << I18n.t(:when_incorrect_guess) && return
  end

  def valid_difficulties?(input)
    DIFFICULTIES.key?(input.to_sym)
  end

  private

  def hint?(input)
    input == GUESS_CODE[:hint]
  end

  def convert_to_array(input)
    input.chars.map(&:to_i)
  end

  def assign_difficulty(difficulty_of_variables)
    @attempts_total = difficulty_of_variables[:attempts]
    @hints_total = difficulty_of_variables[:hints]
    @attempts_left = @attempts_total
    @difficulty = difficulty_of_variables[:difficulty]
  end

  def valid_input?(entity, length)
    return unless validate_presence?(entity)
    return unless validate_length(entity, length)
    return unless validate_match(entity)

    valid_digits?(entity, RANGE_DIGITS)
  end

  def count_attempt
    @attempts_left -= 1
    @attempts_used += 1
  end

  def use_hint
    @errors = []
    @errors << I18n.t(:when_no_hints) && return unless @hints_total.positive?
    count_tip
  end

  def count_tip
    @hints_total -= 1
    @hints_used += 1
    @hints_array ||= secret_code.clone.shuffle
    hint = @hints_array.pop.to_s
    @got_hints += hint
    hint
  end

  def compare_with_right_code(user_code)
    user_code == secret_code
  end

  def secret_code
<<<<<<< HEAD
    @secret_code ||= '1234'#Array.new(AMOUNT_DIGITS) { rand(RANGE_OF_DIGITS) }.join('')
=======
    @secret_code ||= Array.new(AMOUNT_DIGITS) { rand(RANGE_OF_DIGITS) }.join('')
>>>>>>> 52f842a77abe6c6fd68aec9c975658ff2bdd5765
    convert_to_array(@secret_code)
  end

  def guessing(user_code)
<<<<<<< HEAD
    count_attempt
=======
>>>>>>> 52f842a77abe6c6fd68aec9c975658ff2bdd5765
    (@winner = true) && return if compare_with_right_code(user_code)

    pin = []
    clone_secret_code = secret_code.clone
    complex_code = user_code.zip(secret_code)
    complex_code.map do |user_digit, secret_digit|
      next unless user_digit == secret_digit

      pin << '+'
      user_code.delete_at(user_code.index(user_digit))
      clone_secret_code.delete_at(clone_secret_code.index(secret_digit))
    end
    clone_secret_code.each do |x|
      if user_code.include? x
        pin << '-'
        user_code.delete_at(user_code.index(x))
      end
    end
    pin.sort.join('')
  end
end
