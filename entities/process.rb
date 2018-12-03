module MyGame
  class Player
    include Outputs

    attr_reader :name, :hints_total, :attempts_total, :hints_used, :attempts_used, :difficulty, :winner

    def initialize(name:, hints:, attempts:, difficulty:)
      @difficulty = difficulty
      @name = name
      @hints = hints
      @hints_used = 0
      @hints_total = hints
      @attempts = attempts
      @attempts_total = attempts
      @attempts_left = attempts
      @attempts_used = 0
      @secret_code = []
      @winner = false
      @looser = false
      process
    end

    def process
      create_secter_code
      one_iterate while @attempts_left.positive? && @winner == false
      puts @secret_code.inspect
      return lose if @attempts_left < 1
    end

    def true_input_code
      @attempts_left -= 1
      @attempts_used += 1
    end

    def one_iterate
      number = ask_number while check_number(number) == false
      user_code = input_as_arr(number)
      verdict(user_code)
    end

    def check_number(entity)
      return false unless entity.is_a? String

      case entity
      when 'hint' then use_hint
      when 'exit' then leave
      when /^\d{4}$/ then true_input_code
      else wrong_input_code
      end
    end

    def use_hint
      return hint if @hints.positive?

      output_no_hints
      false
    end

    def hint
      @hints -= 1
      puts @secret_code[rand(0..3)]
      @hints_used += 1
      false
    end

    def ask_number
      puts @secret_code.inspect
      output_process
      gets.chomp
    end

    def leave
      output_leave
      exit
    end

    def lose
      output_lose
      @looser = true
    end

    def win
      @winner = true
    end

    def create_secter_code
      4.times { @secret_code << rand(0..6) }
    end

    def verdict(user_code)
      sec_code = @secret_code.map(&:dup)
      return win if user_code == sec_code

      compare_code = user_code.map do |k|
        sec_code.delete(k) if sec_code.include? k
      end
      pin = compare_code.zip(@secret_code).map do |a, b|
        if a == b
          '+'
        elsif a.nil?
          ''
        else '-'
        end
      end
      pin.sort
    end

    def input_as_arr(number)
      number.split('').map(&:to_i)
    end
  end
end
