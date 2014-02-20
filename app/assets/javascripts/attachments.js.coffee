# Client-side attachment handling code. It provides two features:
#
# (1) You can click on a nicely styled button to trigger the upload field,
#     instead of using the native control; and
# (2) The attachment upload form is submitted automatically after a file
#     is selected in the upload dialog.
#
# @author Brendan MacDonell

UPLOAD_FIELD_SELECTOR = '#task-attachments-upload-field'
UPLOAD_BUTTON_SELECTOR = '#task-attachments-upload-button'

$(document).on 'click', UPLOAD_BUTTON_SELECTOR, (event) ->
  $(UPLOAD_FIELD_SELECTOR).click()
  event.preventDefault()

$(document).on 'change', UPLOAD_FIELD_SELECTOR, (event) ->
  $(event.target).closest('form').submit()
  event.preventDefault()
