module LdapUtil
  require 'ldap'
  def self.group_search(name)
    return filter("cn=#{name}", "ou=group,#{LDAP_SUFFIX}")
  end

  def self.user_search(name)
    return filter("uid=#{name}", "ou=People,#{LDAP_SUFFIX}")
  end

  def self.login(login, password)
    ldap = LDAP::Conn.new(host=URL_LDAP)
    begin
      ldap.bind("uid=#{login},ou=People,#{LDAP_SUFFIX}", password)
      return true
    rescue Exception => e
      raise e
    end
  end

  private
  def self.filter(conds, base = nil)
    base ||= LDAP_SUFFIX
    scope = LDAP::LDAP_SCOPE_SUBTREE
    ldap = LDAP::Conn.new(host=URL_LDAP)
    ldap.bind(LDAP_SEARCH_USER, LDAP_SEARCH_PASS)
    ldap.perror("bind")
    result = []
    begin
      ldap.search(base, scope, conds) do |entry|
        result << entry.to_hash
      end
      return result
    rescue LDAP::ResultError
      ldap.perror("search")
      exit
    end
    ldap.perror("search")
    ldap.unbind
  end
end
