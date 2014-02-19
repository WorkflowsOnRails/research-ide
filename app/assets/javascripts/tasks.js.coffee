# Quick-and-dirty server-rendered markdown preview for editing tasks. This
# is needed as no javascript markdown component exactly matches the feature
# set of Kramdown + Sanitizer that we're using in the application, and we
# would like our previews to reflect what will be rendered on the task page.
#
# Note that we bind to anything with the requisite task-body-* IDs. (Ideally,
# we should ensure that they're wrapped in a #task-body-edit element, but in
# reality the application is small, and the IDs aren't reused on other pages.)
#
# @author Brendan MacDonell
PAGE_BODY_SELECTOR = '#task-body-edit'
EDITOR_SELECTOR = '#task-body-edit-field'
PREVIEW_CONTENT_SELECTOR = '#task-body-preview-content'

EDIT_LINK_SELECTOR = '#task-body-edit-link'
PREVIEW_LINK_SELECTOR = '#task-body-preview-link'

showPreview = (html) ->
  $(PAGE_BODY_SELECTOR).addClass('preview')
  $(PREVIEW_CONTENT_SELECTOR).empty().append($(html))

showEditor = () ->
  $(PAGE_BODY_SELECTOR).removeClass('preview')

$(document).on 'click', PREVIEW_LINK_SELECTOR, (event) ->
  content = $(EDITOR_SELECTOR).val()
  $.ajax {
    type: 'POST',
    url: '/tasks/preview',
    data: {content: content},
    dataType: 'html',
    success: (data, _, _xhr) -> showPreview(data)
    error: (xhr, status, error) ->
      alert('An error occurred and the preview could not be shown. Please try again.')
  }
  event.preventDefault()

$(document).on 'click', EDIT_LINK_SELECTOR, (event) ->
  showEditor()
  event.preventDefault()
