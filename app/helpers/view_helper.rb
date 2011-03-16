module ViewHelper


    def format_text(text)
        simple_format(auto_link(h(text)))
    end

    def view_long_text(text)
        %(<div class="view-long-text">#{text}</div>)
    end

    def view_header(type, name)
        %(<div class="view-header"><span class="type">#{h I18n.t(type)}</span> #{h name}</div>)
    end

    # Grupos
    class ViewGroup
        def initialize(view, label, object)
            @view = view
            @label = label
            @object = object
        end

        def row(label, content)
            %(<div class="group-row"><div class="row-label">#{label}</div><div class="row-content">#{content}</div><div class="clear"></div></div>)
        end

        def field(field_name, content)
            row @object.class.human_attribute_name(field_name.to_s), content
        end

        def summary(options = {})
            @view.concat '<div class="group-summary"'
            @view.concat " id=\"#{options[:html_id]}\"" if options[:html_id]
            @view.concat '>'
            yield
            @view.concat '</div>'
        end
    end

    def view_group(label, object = nil)
        concat %(<div class="view-group"><div class="label-group">#{I18n.t label}</div><div>)
        yield ViewGroup.new(self, label, object)
        concat %(</div></div>)
    end


    def bank_account_to_human(bank_account)
        return '' if bank_account.blank?
        bank_account.gsub(/^(....)(....)(..)(.*)$/, '\1 \2 \3 \4')
    end

    def simple_bar_chart(bars)
        labels = bars.map {|bar| bar[0] }
        values = bars.map {|bar| bar[1] }

        labels_y = [0]
        labels_y << (values.max / 2.0).to_i
        labels_y << values.max

        "<img src=\"http://chart.apis.google.com/chart?cht=bvg&amp;chs=#{20 + 50 * bars.size}x200&amp;chd=t:#{values * ","}&amp;chco=764893&amp;chds=0,#{values.max}&amp;chxl=0:|#{labels * "|"}|1:|#{labels_y.join("|")}&amp;chxt=x,y&amp;chbh=30,5,20\" alt=\"\" />"
    end

end
