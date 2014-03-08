# Base application-specific resource class. Inheriting classes must
# provide the following:
#
# 1. a REGEXP constant is set to a Regexp instance that matches any path
#    that should be handled by that resource type.
# 2. a `create` class method that takes a current user and MatchData object
#    (for to a match against ::REGEXP), and returns a resource instance.
#
# BaseResource includes Pundit, so subclasses can use any of the API methods.
# Note that Pundit::authorize is overridden to raise an appropriate RackDAV
# error, instead of Pundit::NotAuthorizedError.
#
# @author Brendan MacDonell
class BaseResource
  include Pundit
  include RackDAV::HTTPStatus

  attr_accessor :current_user, :instance

  def initialize(current_user, instance)
    @current_user = current_user
    @instance = instance
  end

  def authorize(instance, query = nil)
    super
  rescue NotAuthorizedError
    raise Forbidden
  end

  # Given a String holding an arbitrary regular expression, anchored_regexp
  # returns a Regexp instance that ensures that the pattern matches an
  # entire string.
  def self.anchored_regexp(pattern)
    Regexp.new("^#{pattern}$")
  end
end
