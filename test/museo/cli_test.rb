require "test_helper"
require "museo/cli"
require "fileutils"

module Museo
  class CLITest < ActiveSupport::TestCase
    def capture_stdout
      old_stdout = $stdout
      $stdout = StringIO.new("", "w")
      yield
      $stdout.string
    ensure
      $stdout = old_stdout
    end

    def setup
      capture_stdout { described_class.new("clear") }
    end

    def teardown
      capture_stdout { described_class.new("clear") }
    end

    test "#list with no directory" do
      output = capture_stdout { described_class.new("list") }

      assert_includes output, "No directory found: #{Museo.pathname}"
    end

    test "#list with directory but no files" do
      FileUtils.mkdir_p(Museo.pathname("_super_folder_"))

      output = capture_stdout { described_class.new("list", "_super_folder_") }

      assert_includes output, "Directory:"
      assert_includes output, "/_super_folder_"
      assert_includes output, "No files"
    end

    test "#list with directory and files" do
      FileUtils.mkdir_p(Museo.pathname("_super_folder_"))
      FileUtils.touch(Museo.pathname("_super_folder_").join("view.snapshot"))

      output = capture_stdout { described_class.new("list", "_super_folder_") }

      assert_includes output, "Directory:"
      assert_includes output, "/_super_folder_"
      assert_includes output, "view.snapshot"
      refute_includes output, "/view.snapshot"
    end

    test "#list with directory and nested files" do
      FileUtils.mkdir_p(Museo.pathname("Admin::UsersController"))
      FileUtils.touch(Museo.pathname("Admin::UsersController").join("view.snapshot"))

      output = capture_stdout { described_class.new("list", "Admin") }

      assert_includes output, "Directory:"
      assert_includes output, "UsersController/view.snapshot"
    end

    test "#clear removes all files" do
      FileUtils.mkdir_p(Museo.pathname("Admin::UsersController"))
      FileUtils.touch(Museo.pathname("Admin::UsersController").join("view.snapshot"))

      output = capture_stdout { described_class.new("clear") }

      refute File.exist?(Museo.pathname("Admin::UsersController"))
      refute File.exist?(Museo.pathname)

      assert_includes output, "Directory: #{Museo.pathname}"
      assert_includes output, "Removing snapshots"
      assert_includes output, "view.snapshot"
    end

    test "#clear removes files that match a pattern" do
      FileUtils.mkdir_p(Museo.pathname("Admin::UsersController"))
      FileUtils.touch(Museo.pathname("Admin::UsersController").join("view.snapshot"))
      FileUtils.mkdir_p(Museo.pathname("ProductsController"))

      output = capture_stdout { described_class.new("clear", "Admin") }

      assert_match(/Directory: \/.+\/Admin/, output)
      refute File.exist?(Museo.pathname("Admin"))
      assert File.exist?(Museo.pathname("ProductsController"))
    end
  end
end
