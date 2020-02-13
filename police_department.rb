# frozen_string_literal: true

class PoliceDepartment
  include Subject
  attr_reader :observers, :observers_notified
  def initialize()
    @observers = []
    @observers_notified = false
  end

  def notify_blue_car_parked(parking_lot)
    parking_lot.add_observer(self)
    parking_lot.many_colors_car
  end
end