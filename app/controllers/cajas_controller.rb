class CajasController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :caja if Caja.table_exists?
end
