class EmpresasController < ApplicationController
  active_scaffold :empresa do |config|
    # List
    config.list.label = "Empresas"
    config.list.columns = [:nombre, :cif, :localidad_id, :sedes]
    config.columns[:nombre].label = "Empresa"
    config.actions.exclude :show

    # Create
    config.create.columns = [:nombre, :cif, :direccion, :localidad_id, :telefono1, :telefono2, :fax]
    config.create.link.page = true
    
    # Update
    config.update.columns = [:nombre, :cif, :direccion, :localidad_id, :telefono1, :telefono2, :fax]
    config.update.link.page = true

  end

  def return_to_main
    redirect_to :action => 'list'
  end

end
