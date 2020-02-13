# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../parking_space'
require_relative '../owner'
require_relative '../attendant'

describe ParkingSpace do
  system 'clear'
  it 'ensures that the car is parked' do
    honda_city = Object.new
    parking_space = ParkingSpace.new 10
    parking_token = honda_city.object_id

    honda_city_parked = parking_space.park(honda_city)

    assert_equal(parking_token, honda_city_parked)
  end

  it 'ensures that 2 cars are parked' do
    parking_space = ParkingSpace.new 2
    honda_city = Object.new
    honda_civic = Object.new
    city_parking_token = honda_city.object_id
    civic_parking_token = honda_civic.object_id

    assert_equal(city_parking_token, parking_space.park(honda_city))
    assert_equal(civic_parking_token, parking_space.park(honda_civic))
  end

  it 'ensures that only first car is allowed to park' do
    parking_space = ParkingSpace.new 1
    honda_city = Object.new
    honda_civic = Object.new
    city_parking_token = honda_city.object_id

    assert_equal(city_parking_token, parking_space.park(honda_city))
    refute(parking_space.park(honda_civic))
  end

  it 'ensure that the car is unparked' do
    parking_space = ParkingSpace.new 1
    honda_city = Object.new
    city_parking_token = honda_city.object_id

    parking_space.park(honda_city)
    expected = parking_space.unpark(city_parking_token)

    assert_equal(honda_city, expected)
  end

  it 'ensures that same car cannot be parked twice before unparking' do
    parking_space = ParkingSpace.new 2
    honda_city = Object.new

    city_parking_token = honda_city.object_id

    assert_equal(city_parking_token, parking_space.park(honda_city))
    refute(parking_space.park(honda_city))
    assert_equal(honda_city, parking_space.unpark(honda_city.object_id))
    assert_equal(city_parking_token, parking_space.park(honda_city))
  end

  it 'sending notification when the parking space is full' do
    mock = Minitest::Mock.new
    parking_space = ParkingSpace.new 1
    parking_space.add_observer(mock)
    mock.expect :notify_car_parked, parking_space, [Object]
    mock.expect :notify_parking_full, parking_space, [Object]
    honda_city = Object.new
    parking_space.park(honda_city)
    assert mock.verify
    assert mock.verify
  end

  it 'ensures sending notification when parking is free' do
    mock = Minitest::Mock.new
    parking_space = ParkingSpace.new 1
    honda_city = Object.new
    mock.expect :notify_car_parked, parking_space, [Object]
    parking_space.park(honda_city)
    parking_space.add_observer(mock)
    mock.expect :notify_parking_open, parking_space, [Object]

    parking_space.unpark(honda_city.object_id)

    assert mock.verify
  end

  it 'gives the number of available slots' do
    parking_space = ParkingSpace.new 10
    parking_space.park(Object.new)
    available_slots = parking_space.available_slots
    assert_equal(9, available_slots)
  end

  it 'ensures sending notification when car is not available in parking lot' do
    parking_space = ParkingSpace.new 2
    fbi_agent_mock = Minitest::Mock.new
    parking_space.add_observer(fbi_agent_mock)
    honda_city = Object.new
    fbi_agent_mock.expect :notify_car_parked, parking_space, [Object]
    parking_space.park(honda_city)
    fbi_agent_mock.expect :notify_car_parked, parking_space, [Object]
    parking_space.unpark(honda_city.object_id)
    fbi_agent_mock.expect :notify_car_not_found, parking_space, [parking_space]
    parking_space.unpark(honda_city.object_id)
    assert fbi_agent_mock.verify
  end
end