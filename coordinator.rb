# frozen_string_literal: true

require_relative 'parking_staff'
class Coordinator < ParkingStaff
  def initialize(*parking_attendants)
    super()
    @parking_attendants = parking_attendants
    @available_attendants = parking_attendants
    @parking_attendants.each do |attendant|
      attendant.add_observer(self)
    end
  end

  def direct(vehical)
    @available_attendants.each do |attendant|
      return attendant.direct(vehical)
    end
  end

  def notify_parking_full(observing_attendant)
    @available_attendants.delete(observing_attendant)
  end
end
