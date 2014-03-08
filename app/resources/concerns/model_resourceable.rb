# Mixin implementing common functionality for resources that wrap
# ActiveRecord model instances.
#
# @author Brendan MacDonell
module ModelResourceable
  def creation_date
    instance.created_at || Time.now
  end

  def last_modified
    instance.updated_at || Time.now
  end
end
