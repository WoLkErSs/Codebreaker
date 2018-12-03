module Registration
  def registration
    hash_name_hints_attemp = {}
    hash_name_hints_attemp[:name] = ask_name
    hash_name_hints_attemp.merge(difficulty)
  end

  private

  def setup_attemps_and_hints(difficulty)
    case difficulty
    when 'Easy' then easy
    when 'Hard' then hard
    when 'Expert' then expert
    else wrong_difficulty
    end
  end

  def easy
    { attempts: 15, hints: 2, difficulty: 'easy' }
  end

  def hard
    { attempts: 10, hints: 1, difficulty: 'hard' }
  end

  def expert
    { attempts: 5, hints: 1, difficulty: 'expert' }
  end

  def difficulty
    output_difficulty
    difficulty = gets.chomp.capitalize
    setup_attemps_and_hints(difficulty)
  end

  def wrong_difficulty
    output_wrong_difficulty
    difficulty
  end

  def ask_name
    output_ask_name
    name = gets.chomp.capitalize
    check_name(name)
  end

  def check_name(name)
    return ask_name if !(name.is_a? String) || name.length < 3 || name.length > 20
    return leave if name == 'exit'

    name
  end
end
