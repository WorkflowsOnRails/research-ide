# Resource class for the root of the WebDAV hierarchy. It contains resources
# for all of the projects that a user has access to through either ownership
# or membership. See ProjectResource for more information.
#
# @author Brendan MacDonell
class RootResource < BaseResource
  PATTERN = ""
  REGEXP = anchored_regexp(PATTERN)

  include CollectionResourceable

  def self.create(current_user, match)
    self.new(current_user, nil)
  end

  def children
    # We don't need to authorize, since the root resource only presents
    # projects that the current user is assigned to.
    current_user.all_projects.map { |p| ProjectResource.new(current_user, p) }
  end

  def creation_date
    Time.parse("Thu Jan 1 00:00:00 GMT 1970")
  end

  def display_name
    'All Projects'
  end

  def exist?
    true
  end

  def id
    ""
  end

  def last_modified
    creation_date
  end
end
