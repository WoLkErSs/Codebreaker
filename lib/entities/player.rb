class Player
  include Validation

  attr_reader :name
  attr_accessor :errors_store

  MAX_LENGTH = 20
  MIN_LENGTH = 3

  def initialize
    @errors_store = {}
  end

  def assign_name(name)
     validation(name) ? @name = name : @errors_store[:when_wrong_name] = 'Name length must be from 3 to 20 words'
  end

  private

  def validation(name)
    return false if validate_presence?(name)
    validate_length_in_range(name, MIN_LENGTH, MAX_LENGTH)
  end
end
