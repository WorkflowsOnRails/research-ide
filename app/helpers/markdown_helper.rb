# Helper to _safely_ render user-provided markup content to HTML.
#
# @author Brendan MacDonell
module MarkdownHelper
  def render_markdown(text)
    raw_html = Kramdown::Document.new(text).to_html
    cleaned_html = Sanitize.clean(raw_html, Sanitize::Config::RELAXED)
    cleaned_html.html_safe
  end
end
