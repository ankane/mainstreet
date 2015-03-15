require_relative "test_helper"

class TestMainstreet < Minitest::Test
  def test_basic
    address =
      VCR.use_cassette("basic") do
        Address.create(street: "1 infinite loop", zip_code: "95014")
      end

    assert_equal "1 Infinite Loop", address.street
    assert_nil address.street2
    assert_equal "Cupertino", address.city
    assert_equal "CA", address.state
    assert_equal "95014", address.zip_code
    assert_in_delta 37.33053, address.latitude, 0.002
    assert_in_delta -122.02887, address.longitude, 0.002
    assert_equal({"street" => "1 infinite loop", "street2" => nil, "city" => nil, "state" => nil, "zip_code" => "95014"}, address.original_attributes)
    assert address.verification_info
  end

  def test_bad_zip_code
    address =
      VCR.use_cassette("bad_zip_code") do
        Address.create(street: "1 infinite loop", zip_code: "95015")
      end

    assert_equal ["Did you mean 95014?"], address.errors.full_messages
    assert_equal "1 infinite loop", address.street
  end
end
