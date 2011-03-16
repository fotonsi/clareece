class FileWidget < RemixUI::Widgets::Field

  attr_accessor :record_class

  def record
    request_cache[:record] ||=
      begin
        attrs = value
        if attrs.nil?
          nil
        elsif i = attrs[:id]
          record_class.find i
        else
          record_class.new attrs
        end
      end
  end

  def user_value
    v = HashWithIndifferentAccess.new
    v[:uploaded_data] = page.params[fields[:uploaded_data]] if page.params[fields[:uploaded_data]]
    v[:id] = page.params[fields[:id]] if page.params[fields[:id]]
    v
  end

  def fields
    request_cache[:fields] ||=
    %w(id uploaded_data).inject(HashWithIndifferentAccess.new) {|h, n| h[n.to_sym] = build_var_name(n); h}
  end

  def render_html
    %|
      <div #{dom_attributes.to_html}>
        #{page.view.render :partial => 'widgets/file_dialog', :locals => {:widget => self}}
      </div>
    |
  end

end
