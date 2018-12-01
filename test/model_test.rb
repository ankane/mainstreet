require_relative "test_helper"

class ModelTest < Minitest::Test
  def test_success
    address = Address.new(
      street: "1 Infinite Loop",
      city: "Cupertino",
      region: "CA",
      postal_code: "95014"
    )
    assert address.valid?
    assert_in_delta 37.3319, address.latitude, 0.01
    assert_in_delta (-122.0302), address.longitude, 0.01
  end

  def test_failed
    address = Address.new(
      street: "1600 Fake Ave",
      city: "Washington",
      region: "DC",
      postal_code: "20500"
    )
    assert !address.valid?
    assert_equal ["Address can't be confirmed"], address.errors.full_messages
  end

  def test_blank
    address = Address.new
    assert address.valid?
  end

  def test_international_success
    address = Address.new(
      street: "13 Rue Yves Toudic",
      city: "Paris",
      postal_code: "75010",
      country: "France"
    )
    assert address.valid?
    assert_in_delta 48.867, address.latitude, 0.01
    assert_in_delta 2.363, address.longitude, 0.01
  end
end
