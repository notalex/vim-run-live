require 'minitest/autorun'
require 'tmpdir'
require 'vimrunner'
require 'vimrunner/testing'
include Vimrunner::Testing

def vim
  @vim ||= Vimrunner.start_gvim
end

class MiniTest::Spec
  before do
    vim.command("cd #{ tmp_dir_path }")
    plugin_path = File.expand_path('../../../', __FILE__)
    vim.add_plugin(plugin_path, 'plugin/run_live.vim')
  end

  after do
    remove_tmp_directory
    vim.kill
  end

  private

  def tmp_dir_path
    @tmp_dir_path ||= Dir.mktmpdir('vimrunner')
  end

  def remove_tmp_directory
    FileUtils.remove_entry(tmp_dir_path)
  end
end
