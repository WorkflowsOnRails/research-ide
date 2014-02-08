inputs = %w[
  CollectionSelectInput
  DateTimeInput
  FileInput
  GroupedCollectionSelectInput
  NumericInput
  PasswordInput
  RangeInput
  StringInput
  TextInput
]

inputs.each do |input_type|
  superclass = "SimpleForm::Inputs::#{input_type}".constantize

  new_class = Class.new(superclass) do
    def input_html_classes
      super.push('form-control')
    end
  end

  Object.const_set(input_type, new_class)
end


SimpleForm.setup do |config|
  config.boolean_style = :nested

  config.wrappers :bootstrap3, tag: 'div', class: 'form-group',
    error_class: 'has-error',
    defaults: { input_html: { class: 'default_class' } } do |b|

    b.use :min_max
    b.use :maxlength
    b.use :placeholder
    b.use :label

    b.optional :pattern
    b.optional :readonly

    b.wrapper tag: 'div', class: 'col-md-10' do |c|
      c.use :input, wrap_with: { tag: 'div' }
      c.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      c.use :error, wrap_with: { tag: 'span', class: 'help-block has-error' }
    end
  end

  config.wrappers :prepend, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :placeholder
    b.wrapper tag: 'div', class: 'controls' do |input|
      input.wrapper tag: 'div', class: 'input-group' do |prepend|
        prepend.use :label , class: 'input-group-addon' ###Please note setting class here fro the label does not currently work (let me know if you know a workaround as this is the final hurdle)
        prepend.use :input
      end
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      input.use :error, wrap_with: { tag: 'span', class: 'help-block has-error' }
    end
  end

  config.wrappers :append, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :placeholder
    b.wrapper tag: 'div', class: 'controls' do |input|
      input.wrapper tag: 'div', class: 'input-group' do |prepend|
        prepend.use :input
        prepend.use :label , class: 'input-group-addon' ###Please note setting class here fro the label does not currently work (let me know if you know a workaround as this is the final hurdle)
      end
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      input.use :error, wrap_with: { tag: 'span', class: 'help-block has-error' }
    end
  end

  config.label_class = 'col-md-2 control-label'
  config.form_class = 'form-horizontal'

  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://getbootstrap.com/)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :bootstrap3
end
