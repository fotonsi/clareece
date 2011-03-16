module I18nHelper

  def label_with_i18n(object_name, method, text = nil, options = {})
    if text.nil? and (object = instance_variable_get("@#{object_name}"))
      text = object.class.human_attribute_name(method.to_s)
    end

    label_without_i18n(object_name, method, text, options)
  end

  def i18n_bool(value)
    if value == true
      I18n.t "forms.bool.true"
    elsif value == false
      I18n.t "forms.bool.false"
    else
      I18n.t "forms.bool.undef"
    end
  end

  include ActionView::Helpers::FormHelper
  alias_method_chain :label, :i18n



  #    include WillPaginate::ViewHelpers
  #
  #    def will_paginate_with_i18n(collection, options = {})
  #        will_paginate_without_i18n collection, options.merge(:previous_label => I18n.t("pagination.previous"), :next_label => I18n.t("pagination.next"))
  #    end
  #
  #    alias_method_chain :will_paginate, :i18n

end
