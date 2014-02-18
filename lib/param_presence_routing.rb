# TODO
#
# @author Brendan
class ParamPresenceRouting
  def initialize(*options)
    @options = options
  end

  def matches?(request)
    @options.any? { |param| request.params.include? param }
  end
end
