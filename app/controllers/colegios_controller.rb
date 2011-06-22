class ColegiosController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :colegio do |config|
    # General
    config.columns[:nombre].options = {:size => "70%"}
    config.columns[:direccion].options = {:size => "70%"}
    config.columns[:recargo_bancario].options = {:size => 5, :alt => 'decimal'}
    config.columns[:dia_trans_deuda].options = {:size => 2}
    config.columns[:cuota_colegiacion].options = {:size => 5, :alt => 'decimal'}
    config.columns[:cuota_colegiacion_num_plazos].options = {:size => 3, :alt => 'integer'}
    config.columns[:entidad].options = {:size => 4}
    config.columns[:oficina].options = {:size => 4}
    config.columns[:dc].options = {:size => 2}
    config.columns[:cuenta].options = {:size => 10}
    config.columns.add :localidad_id
    config.list.columns = [:nombre, :direccion, :localidad, :email]
    config.update.link.page = true
  end if Colegio.table_exists?

  def after_update_save(record)
    flash[:notice] = I18n.t("active_scaffold.colegio.actualizado")
    redirect_to :action => 'edit', :id => record
  end
end
