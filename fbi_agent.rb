# frozen_string_literal: true

class FbiAgent
  def initialize(parking_lot)
    parking_lot.add_observer(self)
  end

  def update_car_not_found(notification)
    puts notification
  end
end
