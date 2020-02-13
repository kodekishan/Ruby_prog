# frozen_string_literal: true

require_relative 'parking_staff'

class Attendant < ParkingStaff
  attr_reader :available_parking_spaces, :observers
  include Subject
  def initialize(*parking_spaces)
    super()
    @parking_spaces = parking_spaces
    @direction_strategy = ParkingSpace::WITH_FIRST_AVAILABLE
    @parking_spaces.each { |parking_space| parking_space.add_observer(self) }
    @available_parking_spaces = parking_spaces
  end

  def direct(vehicle, another_direction_strategy = nil)
    raise 'Parking Full' if @available_parking_spaces.empty?

    strategy = another_direction_strategy.nil? ? @direction_strategy : another_direction_strategy
    parking_space = strategy.call(@available_parking_spaces)
    parking_space.park(vehicle)
  end

  def notify_parking_full(observing_parking_space)
    @available_parking_spaces.delete(observing_parking_space)
    notify_parking_full_observers(self) if @available_parking_spaces.empty?
  end

  def notify_parking_open(observing_parking_space)
    @available_parking_spaces << observing_parking_space
  end
end
