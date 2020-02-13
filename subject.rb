# frozen_string_literal: true

module Subject
  def add_observer(observer)
    observers << observer
  end

  def delete_observer(observer)
    @observer.delete(observer)
  end

  def notify_car_not_found_observers(notification)
    observers.each { |observer| observer.notify_car_not_found(notification) }
  end

  def notify_parking_open_observers(notification)
    observers.each { |observer| observer.notify_parking_open(notification) }
  end

  def notify_parking_full_observers(notification)
    observers.each { |observer| observer.notify_parking_full(notification) }
  end

  def notify_car_parked_observers(notification)
    observers.each { |observer| observer.notify_car_parked(notification) }
  end

  def notify_traffic_police_observers(notification)
    observers.each { |observer| observer.notify_parking_almost_full(notification) }
  end

  def notify_police_deptartment_observers(notification)
    observers.each {|observer| observer.notify_blue_car_parked(notification)}
  end

  protected

  def notify_parking_open(notification); end

  def notify_parking_full(notification); end

  def notify_car_not_found(notification); end

  def notify_parking_almost_full(notification); end

  def notify_car_parked(notification); end

  def notify_blue_car_parked(notification); end

end