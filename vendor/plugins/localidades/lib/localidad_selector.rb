class LocalidadSelector < RecordSelector

    def as_label
      record.to_label
    end

    def model
        Localidad
    end

    def object_name
        "Localidad"
    end

    def report_options
        {
            :source => { :class_name => model.class_name, :default_conditions => conditions },
            :columns => [ 
              {:name => 'provincia_nombre', :label => 'Provincia'}, 
              :nombre, 
              :cp 
            ]
        }
    end

    remote_method :generate_search_box, :remote_generate_search_box
    def remote_generate_search_box
        page.view.render :partial => 'widgets/record_selector_dialog', :locals => {:widget => self, :report => Report}
    end

    def css_class=(v)
    end

end

