class PermisosController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :permiso do |config|
    config.list.columns = [:descripcion, :nombre]
  end if Permiso.table_exists?
end
