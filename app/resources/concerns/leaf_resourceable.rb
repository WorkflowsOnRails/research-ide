# Mixin that provices common functionality for non-collection resources.
#
# @author Brendan MacDonell
module LeafResourceable
  def children
    []
  end

  def collection?
    false
  end

  def url
    id
  end
end
