# frozen_string_literal: true

class Owner
  attr_reader :unavailable_parking_spaces
  def initialize(*parking_spaces)
    @parking_spaces = parking_spaces
    @parking_spaces.each { |parking_space| parking_space.add_observer(self) }
    @unavailable_parking_spaces = []
  end

  def notify_parking_open(observing_parking_space)
    puts 'Parking is now open'
    @unavailable_parking_spaces.delete(observing_parking_space)
  end

  def notify_parking_full(observing_parking_space)
    puts 'Parking is now full'
    @unavailable_parking_spaces << observing_parking_space
  end

  def notify_car_parked(observing_parking_space); end
end
