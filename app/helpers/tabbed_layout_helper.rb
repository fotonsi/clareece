module TabbedLayoutHelper

  class TabbedLayout
    attr_reader :view
    def initialize(view)
      @view = view
    end

    class Tab
      attr_reader :div
      def initialize(div)
        @div = div
      end
    end

    def tab(options = {}, &block)
      tab = Tab.new(self)
      view.concat %|<div class="tab-content #{options[:css_class]}">
                        <h4 class="tab" title="#{options[:title]}">#{options[:title]}</h4>
                        #{view.capture { block.call(tab) }}
                    </div>|
      
    end
  end
    
  def tabbed_layout(options = {}, &block)
    options[:class] ||= 'tab-container'
    layout = TabbedLayout.new(self)
    concat %|<div #{options.to_html} >
                #{capture { block.call(layout) }}
             </div>
             <script type="text/javascript">
                BuildTabs('#{options[:id]}');
                ActivateTab('#{options[:id]}', 0);
             </script>|
  end

end
