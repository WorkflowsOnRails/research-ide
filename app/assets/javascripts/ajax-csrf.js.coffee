# Ensure that a Rails CSRF token is attached to every AJAX request so that
# they aren't rejected by the Rails request processing logic.
#
# @author Brendan MacDonell
$ () ->
  csrfToken = $('meta[name="csrf-token"]').attr('content')

  $.ajaxSetup {
    beforeSend: (xhr) ->
      xhr.setRequestHeader('X-CSRF-Token', csrfToken)
  }
