require File.dirname(__FILE__) + '/../../test_helper'
require 'action_view/test_case' 

class TinyMCEHelpersTest < ActionView::TestCase

  #
  # For the following, supply as little config options as possible.
  #

  test "using_tiny_mce method works as expected" do
    @uses_tiny_mce = nil
    assert !using_tiny_mce?
    @uses_tiny_mce = false
    assert !using_tiny_mce?
    @uses_tiny_mce = true
    assert using_tiny_mce?
  end

  test "correct tiny mce is loaded depending on environment" do
    Object.const_set('RAILS_ENV', 'development')
    assert_match /\/javascripts\/tiny_mce\/tiny_mce_src\.js/, include_tiny_mce_js
    Object.const_set('RAILS_ENV', 'production')
    assert_match /\/javascripts\/tiny_mce\/tiny_mce\.js/, include_tiny_mce_js
    Object.const_set('RAILS_ENV', 'test') # set it back to test
  end

  test "correct tiny mce is only loaded when using it" do
    @uses_tiny_mce = nil
    assert_nil include_tiny_mce_js_if_needed
    @uses_tiny_mce = true
    assert_not_nil include_tiny_mce_js_if_needed
  end

  test "tiny_mce_init wraps raw js in a javascript tag" do
    assert_equal default_tiny_mce_javascript, tiny_mce_init(Hash.new, String.new)
  end

  test "tiny_mce_init_if_needed only wraps raw js in a javascript tag if needed" do
    @uses_tiny_mce = nil
    assert_nil tiny_mce_init_if_needed
    @uses_tiny_mce = true
    assert_equal default_tiny_mce_javascript, tiny_mce_init_if_needed(Hash.new, String.new)
  end

  test "include_tiny_mce_if_needed outputs the required JS when needed" do
    @uses_tiny_mce = nil
    assert_nil include_tiny_mce_if_needed
    @uses_tiny_mce = true
    assert_match /<script src=.*tiny_mce.js.*<script.*tinyMCE.init/m, include_tiny_mce_if_needed
  end

  #
  # Now we test the formed Javascript (i.e. the raw_tiny_mce_init method)
  #

  test "string, symbol, or fixnum is formed as expected" do
    assert_equal "tinyMCE.init({\ndebug : 'true',\neditor_selector : 'mceEditor',\nmode : 'textareas',\ntheme : 'simple'\n\n});",
                 raw_tiny_mce_init({ 'debug' => 'true' })
    assert_equal "tinyMCE.init({\ndebug : 'true',\neditor_selector : 'mceEditor',\nmode : 'textareas',\ntheme : 'simple'\n\n});",
                 raw_tiny_mce_init({ 'debug' => :true })
    assert_equal "tinyMCE.init({\ndebug : '1',\neditor_selector : 'mceEditor',\nmode : 'textareas',\ntheme : 'simple'\n\n});",
                 raw_tiny_mce_init({ 'debug' => 1 })
  end

  test "array is formed as expected" do
    assert_equal "tinyMCE.init({\neditor_selector : 'mceEditor',\nmode : 'textareas',\nplugins : \"table\",\ntheme : 'simple'\n\n});",
                 raw_tiny_mce_init({ :plugins => %w{table} })
    assert_equal "tinyMCE.init({\neditor_selector : 'mceEditor',\nmode : 'textareas',\nplugins : \"table,contextmenu,paste\",\ntheme : 'simple'\n\n});",
                 raw_tiny_mce_init({ :plugins => %w{table contextmenu paste} })
  end

  test "booleans are formed as expected" do
    assert_equal "tinyMCE.init({\ndebug : true,\neditor_selector : 'mceEditor',\nmode : 'textareas',\ntheme : 'simple'\n\n});",
                 raw_tiny_mce_init({ 'debug' => true })
    assert_equal "tinyMCE.init({\ndebug : false,\neditor_selector : 'mceEditor',\nmode : 'textareas',\ntheme : 'simple'\n\n});",
                 raw_tiny_mce_init({ 'debug' => false })
  end

  test "defaults are overridable" do
    assert_equal "tinyMCE.init({\neditor_selector : 'test-selector',\nmode : 'specific_textareas',\ntheme : 'advanced'\n\n});",
                 raw_tiny_mce_init({ :theme => 'advanced', :mode => 'specific_textareas', :editor_selector => 'test-selector' })
  end

  test "additional tiny mce options can be set in the form of raw js" do
    assert_equal "tinyMCE.init({\neditor_selector : 'mceEditor',\nmode : 'textareas',\ntheme : 'simple',\ntemplate_templates : [ { title : 'Editor Details' }]\n\n});",
                 raw_tiny_mce_init(Hash.new, "template_templates : [ { title : 'Editor Details' }]")
  end

  test "exception is raised when an invalid option is used" do
    assert_raise TinyMCEInvalidOption do
      raw_tiny_mce_init({ 'invalid_option' => true })
    end
  end
  
  test "exception when plugins option is not an array" do
    assert_raise TinyMCEInvalidOptionType do
      raw_tiny_mce_init({'plugins' => 'invalid as a string'})
    end
  end

  test "exception is raised when an invalid option value type is used" do
    assert_raise TinyMCEInvalidOptionType do
      raw_tiny_mce_init({ 'mode' => Class })
    end
  end

  private

  def default_tiny_mce_javascript
    "<script type=\"text/javascript\">\n//<![CDATA[\ntinyMCE.init({\neditor_selector : 'mceEditor',\nmode : 'textareas',\ntheme : 'simple'\n\n});\n//]]>\n</script>"
  end

end
