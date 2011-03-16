include ActionView::Helpers::NumberHelper
module ExportUtils
  def self.formatea_moneda(numero)
    format("%.2f" % numero)
  end

  def self.value2text(value, options = {})
    return if value.nil?
    return value.strftime(ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS[:default]) if [ActiveSupport::TimeWithZone, Time].include? value.class
    return value.strftime(ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:default]) if [Date].include? value.class
    return value if value.kind_of? String
    return (number_to_currency(value, {:unit => '', :separator => ',', :delimiter => '.', :precision => (options[:precision] || 2)}) rescue formatea_moneda(value)) if [Float, BigDecimal].include?(value.class)
    return value.to_s if value.kind_of? Integer
    return as_('Sí') if (value.class == TrueClass)
    return as_('No') if (value.class == FalseClass)
    ((value.descripcion rescue nil ) || (value.to_label rescue nil) || (value.nombre rescue nil) || "")
  end
end
