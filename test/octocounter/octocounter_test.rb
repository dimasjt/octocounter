require "test_helper"

describe Octocounter::Counter do
  describe "#calculate" do
    it "should count files by same content" do
      abcdef, diff = Octocounter::Counter.new("test/data").calculate

      assert_equal abcdef[:files], "test/data/A/content2\ntest/data/B/D/content3\ntest/data/B/content1"
      assert_equal abcdef[:count], 3

      assert_equal diff[:files], "test/data/B/D/diff"
      assert_equal diff[:count], 1
    end
  end
end
