module ApplicationHelper
  # Returns a bootstrap alert CSS class appropriate for a flash level
  # @author Brendan MacDonell
  FLASH_CLASSES = {
    :notice => "alert-info",
    :success => "alert-success",
    :alert => "alert-warning",
    :error => "alert-danger",
  }
  FLASH_CLASSES.default = "alert-info"

  def flash_class(level)
    FLASH_CLASSES[level]
  end

  # Helper for a row of buttons in a form rendered with our default styling
  # @author Brendan MacDonell
  def bootstrap_form_buttons(&block)
    content_tag :div, class: 'form-actions row' do
      content_tag :div, class: 'col-md-10 col-md-offset-2', &block
    end
  end
end
