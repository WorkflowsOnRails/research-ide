# Simple enum class to manage sets of possible values for string fields.
# Using an Enum helps us to catch invalid values when they are referenced,
# instead of when the associated model is validated. It's also helpful in
# cases where we can't add validations to the model in question (ex. the
# Role model, which isn't restricted to only controlling permissions for
# projects.)
#
# @author Brendan MacDonell

class Enum
  def initialize(*names)
    @names = names.map(&:to_s)
    @names.each do |name|
      as_symbol = name.to_sym
      as_string = name.to_s
      define_singleton_method as_symbol, -> { as_string }
    end
  end

  def include?(name)
    @names.include?(name)
  end

  def values
    @names
  end
end
