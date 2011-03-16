class EmpleadosController < ApplicationController
  active_scaffold :empleado do |config|
    # General
    config.label = "Empleados"
    # Añadimos columnas virtuales
    [:nombre_completo, :telefonos].each{|method|
      config.columns.add method
      config.columns[method].sort_by :method => method.to_s
    }
    config.columns[:nombre_completo].label = "Nombre"
    form_columns = [:sede, :nombre, :apellido1, :apellido2, :nif, :sexo, :estado_civil, :numero_hijos, :fecha_nacimiento, :nacionalidad, :direccion, 
      :email, :telefono1, :telefono2, :telefono3, :fecha_alta, :fecha_baja, :categoria_profesional, :cargo_id, :grupo_cotizacion, :contrato, 
      :direccion_centro_trabajo, :numero_ss, :examen_medico_previo, :fecha_examen_medico, :minusvalia, :porcentaje_minusvalia, :carnet_conducir, :idiomas,
      :fecha_alta, :en_nomina, :fecha_baja, :observaciones
    ]

    # List
    config.list.label = "Empleados"
    config.list.columns = [:nombre_completo, :sede_id, :nif, :en_nomina, :email, :telefonos, :cargo_id]
    config.actions.exclude :show

    # Search
    config.actions.exclude :search
    config.actions.add :field_search
    config.field_search.columns = [:nombre]

    # Create
    config.create.edit_after_create = true 
    config.create.columns = form_columns     
    
    # Update
    config.update.columns = form_columns  
  end

end
