# Rails helpers to provide appropriate links to the WebDAV root
# in the user-facing WebDAV documentation.
#
# @author Brendan MacDonell
module ResourceHelper
  def webdav_url_with_dav_scheme
    scheme = (request.scheme == 'https') ? 'davs' : 'dav'
    "#{scheme}://#{request.host}:#{request.port}/files/"
  end

  def webdav_url_with_http_scheme
    "#{request.scheme}://#{request.host}:#{request.port}/files/"
  end
end
