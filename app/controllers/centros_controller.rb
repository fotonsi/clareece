class CentrosController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :centro if Centro.table_exists?
end
