# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../coordinator'
require_relative '../parking_space'
require_relative '../attendant'

describe Coordinator do
  before do
    @honda_city = Object.new
    @expected = @honda_city.object_id
    @p1 = ParkingSpace.new 10
    @attendant = Attendant.new(@p1)
  end

  it 'directs cars to its attendants' do
    coordinator = Coordinator.new(@attendant)
    actual = coordinator.direct(@honda_city)
    assert_equal(@expected, actual)
  end

  # AS A COORDINATOR
  # I WANT TO DIRECT CARS TO MY COORDINATORS
  # TO MANGE TRAFFIC.
  it 'direct cars to coordinators' do
    p2 = ParkingSpace.new 5
    attendant1 = Attendant.new(@p1)
    attendant2 = Attendant.new(p2)
    coordinator1 = Coordinator.new(attendant1)
    coordinator2 = Coordinator.new(coordinator1, attendant2)
    actual = coordinator2.direct(@honda_city)
    assert_equal(@expected, actual)
  end
end
