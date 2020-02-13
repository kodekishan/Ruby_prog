# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../fbi_agent'
require_relative '../parking_space'

describe FbiAgent do
  it 'understands when car is not available in parking lot' do
    agent = FbiAgent.new
    p1 = ParkingSpace.new 10
    p1.add_observer(agent)
    honda_city = Object.new
    parking_token = honda_city.object_id
    p1.park(honda_city)
    p1.unpark(parking_token)

    expected = p1.unpark(parking_token)

    refute(expected)
  end
end
