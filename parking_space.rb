# frozen_string_literal: true

require_relative 'subject'

class ParkingSpace
  attr_accessor :observers, :occupied, :parked_vehicles_token
  attr_reader :slots, :vehicles, :parking_full_observers, :car_unavailable_observers
  include Subject
  WITH_MORE_SLOTS = proc do |parking_spaces|
    champion = parking_spaces[0]
    parking_spaces.each do |challenger|
      if challenger.available_slots > champion.available_slots
        champion = challenger
      end
    end
    champion
  end

  WITH_LIMITED_SLOTS = proc do |parking_spaces|
    champion = parking_spaces[0]
    parking_spaces.each do |challenger|
      if challenger.available_slots < champion.available_slots
        champion = challenger
      end
    end
    champion
  end

  WITH_FIRST_AVAILABLE = proc do |parking_spaces|
    champion = parking_spaces[0]
    parking_spaces.each do |challenger|
      unless challenger.parking_full?
        champion = challenger
        break
      end
    end
    champion
  end

  def initialize(slots, occupied = 0)
    @observers = []
    @slots = slots
    @occupied = occupied
    @vehicles = Hash.new { |h,k| h[k] = [] }
    @parked_vehicles_token = []
  end

  def park(vehicle)
    return false if @vehicles.values.include?(vehicle) || parking_full?

    @occupied += 1
    notify_parking_full_observers(self) if parking_full?
    notify_car_parked_observers(self)
    parking_token = vehicle.object_id
    @parked_vehicles_token << parking_token
    @vehicles[parking_token] = vehicle
    parking_token
  end

  def unpark(parking_token)
    return notify_car_not_found_observers(self) unless car_found?(parking_token)

    @occupied -= 1
    notify_car_parked_observers(self)
    notify_parking_open_observers(self) if parking_open?
    @vehicles.delete(parking_token)
  end

  def available_slots
    @slots - @occupied
  end

  def parking_full?
    @slots == @occupied
  end

  def is_blue_car_parked?
    vehicles.key('blue')
  end

  private

  def car_found?(parking_token)
    @parked_vehicles_token.include?(parking_token) && @vehicles.keys.include?(parking_token)
  end

  def parking_open?
    @occupied == (@slots - 1)
  end

end