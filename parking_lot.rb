# frozen_string_literal: true

class ParkingLot
  include Subject
  attr_reader :observers, :observers_notified 
  def initialize(*parking_spaces)
    @parking_spaces = parking_spaces
    @observers = []
    parking_spaces.each { |parking_space| parking_space.add_observer(self) }
    
    @observers_notified = false
  end

  def notify_car_parked(_observing_parking_space)
    if is_80_percent_filled? && !@observers_notified
      puts 'Almost full more than 80'
      @observers_notified = true
      notify_traffic_police_observers(self)
    elsif !is_80_percent_filled?
      @observers_notified = false
    end
  end

  def many_colors_car
    @parking_spaces.each {|parking_space| return parking_space.is_blue_car_parked?}
  end

  private

  def is_80_percent_filled?
    total_slots = @parking_spaces.map(&:slots).reduce(0) { |sum, acc| sum + acc }
    occupied_slots = @parking_spaces.map(&:occupied).reduce(0) { |sum, acc| sum + acc }
    occupied_slots >= (total_slots * 0.8)
  end
end