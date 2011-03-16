class TipoDestinosController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :tipo_destino if TipoDestino.table_exists?
end
