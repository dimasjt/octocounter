require "test_helper"

describe Octocounter::Counter do
  describe "#calculate" do
    it "should count files by same content" do
      abcdef, diff = Octocounter::Counter.new("test/data", true).calculate

      assert_equal abcdef[:files], "A/content2\nB/D/content3\nB/content1\ncontent1"
      assert_equal abcdef[:count], 4

      assert_equal diff[:files], "B/D/diff"
      assert_equal diff[:count], 1
    end
  end
end
