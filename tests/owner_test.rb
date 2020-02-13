# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../parking_space'
require_relative '../owner'

describe Owner do
  it 'marks the parking space as unavailable when full' do
    p1 = ParkingSpace.new 1
    owner = Owner.new(p1)
    honda_city = Object.new
    p1.park(honda_city)
    parking_spaces = owner.unavailable_parking_spaces
    assert_includes(parking_spaces, p1)
  end

  it 'marks the parking space as available when its free again' do
    p1 = ParkingSpace.new 1
    owner = Owner.new(p1)
    honda_city = Object.new
    p1.park(honda_city)
    p1.unpark(honda_city.object_id)
    parking_spaces = owner.unavailable_parking_spaces
    refute(parking_spaces.include?(p1))
  end

  it 'marks the lot as full when all parking spaces are full ' do
    p1 = ParkingSpace.new 10, 9
    p2 = ParkingSpace.new 10, 9
    owner = Owner.new(p1, p2)

    p1.park(Object.new)
    p2.park(Object.new)

    assert_equal([p1, p2], owner.unavailable_parking_spaces)
  end

  it 'marks the lot as open when there is at least 1 open parking space ' do
    p1 = ParkingSpace.new 10, 9
    p2 = ParkingSpace.new 10, 9
    owner = Owner.new(p1, p2)
    honda_city = Object.new
    p1.park(honda_city)
    p2.park(Object.new)

    p1.unpark(honda_city.object_id)

    assert_equal([p2], owner.unavailable_parking_spaces)
  end
end
