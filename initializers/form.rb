class CustomFormBuilder < ActionView::Helpers::FormBuilder

  def date_select(method, options = {}, html_options = {})
    if options[:picker]
      existing_date = @object.send(method)
      formatted_date = existing_date.to_date.strftime("%F") if existing_date.present?
      @template.content_tag(:div, :class => "input-group") do
        text_field(method, :value => formatted_date, :class => "form-control datepicker", :"data-date-format" => "YYYY-MM-DD") +
        @template.content_tag(:span, @template.content_tag(:span, "", :class => "fa fa-calendar") ,:class => "input-group-addon")
      end
    else
      super
    end
  end

  def datetime_select(method, options = {}, html_options = {})
    if options[:picker]
      existing_time = @object.send(method)
      formatted_time = existing_time.to_time.strftime("%F %I:%M %p") if existing_time.present?
      @template.content_tag(:div, :class => "input-group") do
        text_field(method, :value => formatted_time, :class => "form-control datetimepicker", :"data-date-format" => "YYYY-MM-DD hh:mm A") +
        @template.content_tag(:span, @template.content_tag(:span, "", :class => "fa fa-calendar") ,:class => "input-group-addon")
      end
    else
      super
    end
  end

end

# Set CustomBuilder as default FormBuilder
ActionView::Base.default_form_builder = CustomFormBuilder