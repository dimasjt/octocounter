require "test_helper"

class OctocounterTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Octocounter::VERSION
  end
end
