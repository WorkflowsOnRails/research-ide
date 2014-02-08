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

  # Helper that outputs "active" if a controller is active, or an
  # empty string otherwise. Used to flag navigation links active
  # when the controller they correspond to is visited.
  #
  # @author Brendan MacDonell
  def nav_class_for_controller(*controller)
    is_active = controller.include?(params[:controller])
    is_active ? "active" : ""
  end

  # Render a datetime into a format useable by jquery.localtime
  # @author Brendan MacDonell
  def render_datetime(datetime, format='')
    return nil if datetime.nil?
    content_tag :span, datetime.iso8601, {'data-localtime-format' => format}
  end

  # Helper for a row of buttons in a form rendered with our default styling
  # @author Brendan MacDonell
  def bootstrap_form_buttons(&block)
    content_tag :div, class: 'form-actions row' do
      content_tag :div, class: 'col-md-10 col-md-offset-2', &block
    end
  end
end
