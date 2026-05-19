require_relative '../test_helper'

class RedmineSubsimplifyConfigurationTest < ActiveSupport::TestCase
  fixtures :users

  def setup
    @original_settings = Setting.plugin_redmine_subsimplify.dup
    Setting.plugin_redmine_subsimplify = {
      'simplified_roles'  => [],
      'simplified_groups' => [],
      'hide_sidebar'      => 'false',
      'hide_top_menu'     => 'false',
      'hide_footer'       => 'false',
      'hide_my_account'   => 'false',
      'hide_overview'     => 'false',
      'hide_filters'      => 'false',
      'hide_user_issues'  => 'false',
      'hide_user_projects' => 'false',
      'hide_user_activity' => 'false',
      'hide_user_others'  => 'false'
    }
  end

  def teardown
    Setting.plugin_redmine_subsimplify = @original_settings
  end

  def test_plugin_is_registered
    plugin = Redmine::Plugin.find(:redmine_subsimplify)
    assert_not_nil plugin
    assert_equal 'Redmine Subsimplify', plugin.name
  end

  def test_nil_user_is_not_simplified
    assert_equal false, RedmineSubsimplify::Configuration.simplified_user?(nil)
  end

  def test_admin_user_is_not_simplified
    assert_equal false, RedmineSubsimplify::Configuration.simplified_user?(users(:admin))
  end

  def test_hide_sidebar_false_when_setting_is_false
    assert_equal false, RedmineSubsimplify::Configuration.hide_sidebar?
  end

  def test_hide_sidebar_true_when_setting_is_true
    Setting.plugin_redmine_subsimplify = Setting.plugin_redmine_subsimplify.merge('hide_sidebar' => 'true')
    assert_equal true, RedmineSubsimplify::Configuration.hide_sidebar?
  end

  def test_hide_sidebar_true_with_boolean_value
    Setting.plugin_redmine_subsimplify = Setting.plugin_redmine_subsimplify.merge('hide_sidebar' => true)
    assert_equal true, RedmineSubsimplify::Configuration.hide_sidebar?
  end

  def test_hide_top_menu_false_by_default
    assert_equal false, RedmineSubsimplify::Configuration.hide_top_menu?
  end

  def test_hide_footer_false_by_default
    assert_equal false, RedmineSubsimplify::Configuration.hide_footer?
  end
end
