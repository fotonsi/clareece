require 'erb'

module ERB::Util

    def hash_to_html(hash)
        hash.map {|key, value| %|#{h key}="#{h value}"|  }.join(" ")
    end

    module_function :hash_to_html

    def html_escape_with_entities(string)
        html_escape(string).gsub(/&amp;([a-zA-Z]{1,15};)/, '&\1')
    end

    module_function :html_escape_with_entities

end

class Hash
    def to_html
        ERB::Util.hash_to_html self
    end

    def to_hash_without_indifferent_access
        Hash.value_for_hash_without_indifferent_access(self, {})
    end

    class <<self
        def value_for_hash_without_indifferent_access(value, converted_objects)
            converted_objects[value] ||=
                case value
                    when Hash
                        newhash = {}
                        value.each_pair {|key, value|
                            newhash[key.to_s] = value_for_hash_without_indifferent_access(value, converted_objects)
                        }
                        newhash
                    when Array
                        value.map {|item| value_for_hash_without_indifferent_access(item, converted_objects) }
                    else
                        value
                    end
        end
    end
end


class String

    # Generate a random string with a fixed width
    def self.generate_random(nchars = 30)
        str = ''
        while str.size < nchars
            str << rand(36).to_s(36)
        end
        str
    end

end
