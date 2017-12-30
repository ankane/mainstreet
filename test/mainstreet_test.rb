require_relative "test_helper"

class TestMainstreet < Minitest::Test
  def test_basic
    address = create_address("basic", "1 infinite loop", "95014")
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

  def test_bad_address
    address = create_address("bad_address", "123 fake tyrannosaurus st", "10000")
    assert_equal ["Address can't be confirmed"], address.errors.full_messages
  end

  def test_bad_zip_code
    address = create_address("bad_zip_code", "1 infinite loop", "95015")
    assert_equal ["Did you mean 95014?"], address.errors.full_messages
    assert_equal "1 infinite loop", address.street
  end

  def test_blank_street
    address = create_address("blank_street", nil, nil)
    assert_equal ["Street can't be blank"], address.errors.full_messages
  end

  def test_blank_zip_code
    address = create_address("blank_zip_code", "123 main st", nil)
    assert_equal ["Address can't be confirmed"], address.errors.full_messages
  end

  protected

  def create_address(label, street, zip_code)
    VCR.use_cassette(label) do
      Address.create(street: street, zip_code: zip_code)
    end
  end
end
