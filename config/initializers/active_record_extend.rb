class ActiveRecord::Base

  # Model.options_for_select options
  #   return a list with options for a select.
  #   
  #   options: {:label => ..., :value => ..., :empty_option => ..., :conditions => ..., :order => ...}
  #
  def self.options_for_select(options = {})
    label_method = options[:label] || content_columns.first.name
    value_method = options[:value] || 'id'
    list_options = options[:empty_option] ? [[I18n.t('active_scaffold._select_'), nil]] : []
    data = find(:all, :order => options[:order], :conditions => options[:conditions]).map {|r| [r.send(label_method), r.send(value_method)]}
    data = data.sort_by{|i| i.first|| ""} unless options[:order]
    list_options += data
    return list_options
  end

  numeric_fields :decimals => 2, :masked => true
end
