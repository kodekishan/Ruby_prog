# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../parking_space'
require_relative '../attendant'

describe Attendant do
  system 'clear'
  it 'Ensures that an attendant is directing car to ther respective space' do
    p1 = ParkingSpace.new 10
    p2 = ParkingSpace.new 2

    attendant = Attendant.new(p1, p2)
    honda_city = Object.new
    actual = honda_city.object_id
    expected = attendant.direct(honda_city)
    assert_equal(actual, expected)
  end

  it 'Ensures that an attendant is directing car to ther respective space' do
    p1 = ParkingSpace.new 1
    p2 = ParkingSpace.new 2

    attendant = Attendant.new(p1, p2)
    honda_city = Object.new
    honda_civic = Object.new
    actual = honda_civic.object_id
    attendant.direct(honda_city, ParkingSpace::WITH_FIRST_AVAILABLE)
    expected = attendant.direct(honda_civic, ParkingSpace::WITH_FIRST_AVAILABLE)
    assert_equal(actual, expected)
  end

  it 'Ensures that an attendant is not directing car if there is no space' do
    p1 = ParkingSpace.new 1
    attendant = Attendant.new(p1)
    attendant.direct(Object.new)
    assert_raises(RuntimeError) do
      attendant.direct(Object.new)
    end
  end

  # AS AN ATTENDANT
  # I WANT TO BE NOTIFIED WHEN MY PARKING SPACE IS FULL
  # SO THAT I CAN PUT A FULL SIGN BOARD

  it 'marks the space as unavailable when the parking space is full' do
    p1 = ParkingSpace.new 1
    attendant = Attendant.new(p1)
    honda_city = Object.new

    attendant.direct(honda_city)

    assert(attendant.available_parking_spaces.empty?)
  end

  it 'directs car to the parking space which has more free slots ' do
    p1 = ParkingSpace.new 1
    p2 = ParkingSpace.new 2

    attendant = Attendant.new(p1, p2)
    honda_city = Object.new
    attendant.direct(honda_city, ParkingSpace::WITH_MORE_SLOTS)
    p2_vehicles = p2.vehicles.values
    assert_includes(p2_vehicles, honda_city)
  end

  it 'attendant directs car to the parking space which has more free slots ' do
    p1 = ParkingSpace.new 10
    p2 = ParkingSpace.new 20

    attendant = Attendant.new(p1, p2)
    honda_city = Object.new
    attendant.direct(honda_city, ParkingSpace::WITH_LIMITED_SLOTS)
    p1_vehicles = p1.vehicles.values
    assert_includes(p1_vehicles, honda_city)
  end

  it 'marks the parking space as available when its free again' do
    p1 = ParkingSpace.new 1
    attendant = Attendant.new(p1)
    honda_city = Object.new

    attendant.direct(honda_city)
    p1.unpark(honda_city.object_id)
    parking_spaces = attendant.available_parking_spaces
    assert_includes(parking_spaces, p1)
  end

  it 'sends notification when all parking spaces are full' do
    p1 = ParkingSpace.new 10
    p2 = ParkingSpace.new 10
    attendant = Attendant.new(p1, p2)
    19.times { attendant.direct(Object.new) }
    coordinator = Minitest::Mock.new
    attendant.add_observer coordinator
    coordinator.expect :notify_parking_full, attendant, [attendant]
    honda_city = Object.new
    attendant.direct(honda_city)
    assert_mock coordinator
  end
end
