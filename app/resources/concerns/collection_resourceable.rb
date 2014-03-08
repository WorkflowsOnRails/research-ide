# Mixin that provides common functionality for collection resources,
# ie. resources that contain child elements (such as projects.)
#
# Collection resources can render an HTML index of their content, but
# do not allow users to create, modify, or delete them.
#
# @author Brendan MacDonell
module CollectionResourceable
  include RackDAV::HTTPStatus

  def collection?
    true
  end

  def content_length
    4096   # 4KB, to look like an EXT inode.
  end

  def content_type
    'text/html'
  end

  def resource_type
    Nokogiri::XML::fragment('<D:collection xmlns:D="DAV:"/>').children.first
  end

  def get(request, response)
    authorize instance, :show? if instance.present?

    locals = {children: children, resource: self}
    controller = ActionController::Base.new()
    content = controller.render_to_string(partial: 'resources/index', locals: locals)

    response.body = [content]
    response['Content-Length'] = content.bytesize
    response['Content-Type'] = 'text/html'
  end

  def post(request, response)
    raise Forbidden
  end

  def put(request, response)
    raise Forbidden
  end

  def copy(request, response)
    raise Forbidden
  end

  def move(request, response)
    raise Forbidden
  end

  def delete(request, response)
    raise Forbidden
  end

  def url
    "#{id}/"
  end
end
