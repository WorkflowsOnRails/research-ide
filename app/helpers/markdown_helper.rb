# Helper to _safely_ render user-provided markup content to HTML.
#
# @author Brendan MacDonell
module MarkdownHelper
  # Make sure that we don't strip out MathJax scripts, but we still
  # strip out any elements that could cause cross-site scripting attacks.
  MATHJAX_TRANSFORMER = lambda do |env|
    node      = env[:node]
    node_name = env[:node_name]

    return if env[:is_whitelisted] || !node.element?
    return unless node_name == 'script'
    return unless node['type'] == 'math/tex; mode=display'

    Sanitize.clean_node!(node, {
      elements: %w[script],
      attributes: { 'script' => %w[id type] }
    })

    {:node_whitelist => [node]}
  end

  SANITIZER = Sanitize::Config::RELAXED
  SANITIZER[:transformers] = [MATHJAX_TRANSFORMER]

  def render_markdown(text)
    raw_html = Kramdown::Document.new(text).to_html
    cleaned_html = Sanitize.clean(raw_html, SANITIZER)
    cleaned_html.html_safe
  end

end
