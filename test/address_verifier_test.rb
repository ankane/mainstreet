require_relative "test_helper"

class AddressVerifierTest < Minitest::Test
  def test_success
    address = "1 Infinite Loop, Cupertino, CA 95014"
    verifier = MainStreet::AddressVerifier.new(address)
    assert verifier.success?
    assert_nil verifier.failure_message
    assert_in_delta 37.3319, verifier.latitude, 0.01
    assert_in_delta (-122.0302), verifier.longitude, 0.01
  end

  def test_failed
    address = "1 Fake Loop, Cupertino, CA 95014"
    verifier = MainStreet::AddressVerifier.new(address)
    assert !verifier.success?
    assert_equal "Address can't be confirmed", verifier.failure_message
    assert_nil verifier.latitude
    assert_nil verifier.longitude
  end

  def test_failed_suite
    address = "122 Mast Rd, Lee, NH 03861"
    verifier = MainStreet::AddressVerifier.new(address)
    if smarty_streets?
      assert !verifier.success?
      assert_equal "Apartment or suite is missing", verifier.failure_message
    else
      assert verifier.success?
    end
  end

  def test_international_success
    address = "13 Rue Yves Toudic, Paris 75010"
    verifier = MainStreet::AddressVerifier.new(address, country: "France")
    assert verifier.success?
    assert_nil verifier.failure_message
    assert_in_delta 48.867, verifier.latitude, 0.01
    assert_in_delta 2.363, verifier.longitude, 0.01
  end

  def test_international_failed
    address = "99 Fictitious St, Westminster, London SW1A 2AA"
    verifier = MainStreet::AddressVerifier.new(address, country: "GBR")
    assert !verifier.success?
  end

  def test_i18n
    address = "1 Fake Loop, Cupertino, CA 95014"
    verifier = MainStreet::AddressVerifier.new(address, locale: :fr)
    assert_equal "Cette adresse n’est pas reconnue", verifier.failure_message
  end

  def test_language_option
    address = "Cologne, Germany"
    verifier = MainStreet::AddressVerifier.new(address, language: :de)
    assert verifier.success?
    assert_equal "Köln", verifier.result.city
    assert_equal "Deutschland", verifier.result.country
  end
end
