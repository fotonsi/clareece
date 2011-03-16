module SecurityForPluginEmpresas

  # Sólo se permite borrar si no tiene nada asociado.
  def authorized_for_destroy?
    self.class.reflections.reject{|k,v| v.macro == :belongs_to}.keys.all?{|k| self.send(k).blank?}
  end

end
