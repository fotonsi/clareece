class Rol < ActiveRecord::Base
  has_and_belongs_to_many :permisos
  has_and_belongs_to_many :usuarios

  def to_label
    self.descripcion
  end

  def importar_usuarios_ldap
    group = LdapUtil.group_search(self.nombre)[0]
    members = group['memberUid'].map {|m| LdapUtil.user_search(m)[0]} if group
    return "Empty group, no user created." if members.blank?
    members.each do |u|
      us = Usuario.find_by_login(u['uid'][0]) || Usuario.new(:login => u['uid'][0])
      us.nombre = u['cn'][0]
      us.roles << self unless us.roles.include?(self)
      us.origen_type = 'ldap'
      us.save
    end
  end
end
