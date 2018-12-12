class Game
  include Validation

  AMOUNT_DIGITS = 4
  RANGE_OF_DIGITS = { first: 0, last: 6 }.freeze
  DIFFICULTY_LEVELS = {
                        easy: 'Easy',
                        hard: 'Hard',
                        expert: 'Expert' }.freeze
  GUESS_CODE = { hint: 'hint', leave: 'exit' }.freeze

  attr_reader :name, :hints_total, :attempts_total, :hints_used, :attempts_used, :difficulty, :winner, :attempts_left
  attr_accessor :errors
  def initialize
    @errors = []
    @hints_used = 0
    @attempts_used = 0
    @secret_code = (0...AMOUNT_DIGITS).map { rand(RANGE_OF_DIGITS[:first]..RANGE_OF_DIGITS[:last]) }
    @arr_for_hints = @secret_code.map(&:dup).shuffle(random: Random.new(1))
  end

  def try(user_inputed_code)
    return use_hint if user_inputed_code == GUESS_CODE[:hint]

    verdict(user_inputed_code.split('').map(&:to_i)) if check_input(user_inputed_code)
  end

  def set_up_difficulty(difficulty, name)
    @name = name
    case difficulty
    when DIFFICULTY_LEVELS[:easy] then easy
    when DIFFICULTY_LEVELS[:hard] then hard
    when DIFFICULTY_LEVELS[:expert] then expert
    end
  end

  private

  def check_input(entity)
    if validation(entity)
      to_count_try
    else
      @errors << I18n.t(:wrong_input_code)
      false
    end
  end

  def validation(entity)
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
        guess_code.delete_at(x)
      end
    end
    pin.sort
  end

  def easy
    @attempts_total = 15
    @hints_total = 2
    @attempts_left = @attempts_total
    @difficulty =  DIFFICULTY_LEVELS[:easy]
  end

  def hard
    @attempts_total = 10
    @hints_total = 1
    @attempts_left = @attempts_total
    @difficulty =  DIFFICULTY_LEVELS[:hard]
  end

  def expert
    @attempts_total = 5
    @hints_total = 1
    @attempts_left = @attempts_total
    @difficulty =  DIFFICULTY_LEVELS[:expert]
  end
end
