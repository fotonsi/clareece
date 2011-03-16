module FieldSearch
  def self.included(base)
    base.send(:extend, ClassMethods)
  end

  module ClassMethods

    # Para los campos de búsqueda de fechas es necesario definir el método self.condition_for_campo_column en el controlador 
    # porque en production no se llama automáticamente a condition_for_datetime_type cuando se trata de un campo de fecha.

    def condition_for_datetime_type(column, value, like_pattern)
      return [] if value[:from].blank? && value[:to].blank?
      conds = [[]]
      if !value[:from].blank?
        value[:from] += ' 00:00' if value[:from] !~ / \d?\d:\d\d$/
        conds[0] << "#{column.search_sql} >= ?"
        conds << value[:from].to_time
      end
      if !value[:to].blank?
        value[:to] += ' 23:59:59' if value[:to] !~ / \d?\d:\d\d$/
        conds[0] << "#{column.search_sql} <= ?"
        conds << value[:to].to_time
      end
      conds[0] = conds[0].join(" and ")
      conds
    end
    alias_method :condition_for_date_type, :condition_for_datetime_type
    alias_method :condition_for_time_type, :condition_for_datetime_type
    alias_method :condition_for_timestamp_type, :condition_for_datetime_type

    def conditions_for_tilde(value)
      "TRANSLATE(#{value}::text, 'áéíóúÁÉÍÓÚ', 'aeiouAEIOU')"
    end

    def conditions_for_text(value, columns, like_pattern="'%?%'")
      conds = []
      value.split.each do |word|
        conds << "(" + columns.map{|column| "#{conditions_for_tilde(column)} ILIKE #{conditions_for_tilde(like_pattern.sub('?', word))}"}.join(' OR ') + ")"
      end
      conds.join(" AND ")
    end

    def colegiado_autocomplete_results(term)
      col = Colegiado.find_by_num_colegiado(term[1..-1])
      [{:to_label => col.to_label, :id => col.id}]
    end
  end
end
