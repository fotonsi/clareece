class ImpuestosController < ApplicationController
  active_scaffold :impuesto do |config|
    config.list.columns = [:nombre, :valor]
    config.create.columns = [:nombre, :valor]
    config.update.columns = [:nombre, :valor]
  end
end
