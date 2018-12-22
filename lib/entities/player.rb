class Player
  include Validation

  attr_reader :name
  attr_accessor :errors_store

  MAX_LENGTH = 20
  MIN_LENGTH = 3

  def assign_name(name)
    @errors_store = []
    validate_name(name) ? @name = name : @errors_store << I18n.t(:when_wrong_name)
  end

  private

  def validate_name(name)
    return false if validate_presence?(name)

    validate_length_in_range(name, MIN_LENGTH, MAX_LENGTH)
  end
end
