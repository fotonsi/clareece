class ExternosController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :externo do |config|
    config.list.columns = [:nif, :nombre_completo]
    config.create.columns = [:nombre, :apellido1, :apellido2, :nif]
    config.update.columns = [:nombre, :apellido1, :apellido2, :nif]
    config.create.link.page = true
    config.update.link.page = true
    config.columns[:apellido1].label = "P. apellido"
    config.columns[:apellido2].label = "S. apellido"
    config.list.label = "Usuarios externos"
  end if Externo.table_exists?

  def return_to_main
    redirect_to :action => :index
  end
end
