class Hash
  def to_html(hash)
    hash.map {|key, value| %|#{h key}="#{h value}"|  }.join(" ")
  end
end
