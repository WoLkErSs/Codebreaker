require 'pry'
class Game
  include Validation

  AMOUNT_DIGITS = 4
  DIFFICULTY = {
                'easy': {attempts: 15, hints: 2, difficulty: 'easy'},
                'hard': {attempts: 10, hints: 2, difficulty: 'hard'},
                'expert': {attempts: 5, hints: 1, difficulty: 'expert'}}.freeze
  RANGE_OF_DIGITS = { first: 0, last: 6 }.freeze
  DIFFICULTY_LEVELS = {
                        easy: 'Easy',
                        hard: 'Hard',
                        expert: 'Expert' }.freeze
  GUESS_CODE = { hint: 'hint', leave: 'exit' }.freeze

  attr_reader :name, :hints_total, :attempts_total, :hints_used, :attempts_used, :difficulty, :winner, :attempts_left
  attr_accessor :errors

  def initialize(user_difficulty:, user_name:)
    @name = user_name
    @errors = []
    @hints_used = 0
    @attempts_used = 0
    @secret_code = []
    AMOUNT_DIGITS.times { @secret_code << rand(RANGE_OF_DIGITS[:first]..RANGE_OF_DIGITS[:last]) }
    @arr_for_hints = @secret_code.map(&:dup).shuffle(random: Random.new(1))
    assign_settings(user_difficulty)
  end

  def try(guess_input)
    return use_hint if guess_input == GUESS_CODE[:hint]

    verdict(guess_input.split('').map(&:to_i)) if check_input(guess_input)
  end

  private

  def assign_settings(difficulty)
    case difficulty
    when DIFFICULTY_LEVELS[:easy] then assign_difficulty( DIFFICULTY[:easy] )
    when DIFFICULTY_LEVELS[:hard] then assign_difficulty( DIFFICULTY[:hard] )
    when DIFFICULTY_LEVELS[:expert] then assign_difficulty( DIFFICULTY[:expert] )
    end
  end

  def assign_difficulty(dif_variables)
    @attempts_total = 2#dif_variables[:attempts]
    @hints_total = dif_variables[:hints]
    @attempts_left = @attempts_total
    @difficulty = dif_variables[:difficulty]
  end

  def check_input(entity)
    if validation(entity, AMOUNT_DIGITS)
      to_count_try
    else
      @errors << I18n.t(:wrong_input_code)
      false
    end
  end

  def validation(entity, length)
    return false if validate_presence?(entity)
    return if !validate_length(entity, length)
    validate_match(entity)
  end

  def to_count_try
    @attempts_left -= 1
    @attempts_used += 1
  end

  def use_hint
    if !@hints_total.positive?
      @errors << I18n.t(:when_no_hints)
      false
    else
      @hints_total -= 1
      @hints_used += 1
      @arr_for_hints.pop
    end
  end

  def verdict(user_code)
    return @winner = true if user_code == @secret_code

    pin = []
    sec_code = @secret_code.map(&:dup)
    guess_code = user_code.map(&:dup)

    a = user_code.zip(@secret_code)
    a.map do |user_digit, secret_digit|
      if user_digit == secret_digit
        pin << '+'
        guess_code.delete_at(guess_code.index(user_digit))
        sec_code.delete_at(sec_code.index(secret_digit))
      end
    end
    sec_code.each do |x|
      if guess_code.include? x
        pin << '-'
      end
    end
    pin.sort
  end
end
