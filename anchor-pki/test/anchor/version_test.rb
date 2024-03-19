# frozen_string_literal: true

require_relative '../test_helper'

# Tests for Anchor::VERSION
class TestVersion < Minitest::Test
  def test_has_a_version_number
    refute_nil ::Anchor::VERSION
  end

  def test_matches_semantic_versioning
    assert_match(/\A\d+\.\d+\.\d+\z/, ::Anchor::VERSION)
  end
end
