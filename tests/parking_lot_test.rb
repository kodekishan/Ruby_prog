# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../parking_space'
require_relative '../parking_lot'
require_relative '../police_department'

describe ParkingLot do
  system 'clear'
  it 'notifes when parking lot is 80 % full' do
    parking_space1 = ParkingSpace.new 3
    parking_space2 = ParkingSpace.new 2
    traffic_police_mock = Minitest::Mock.new
    parking_lot = ParkingLot.new(parking_space1, parking_space2)
    parking_lot.add_observer traffic_police_mock
    3.times { parking_space1.park(Object.new) }
    traffic_police_mock.expect :notify_parking_almost_full, parking_lot, [parking_lot]

    parking_space2.park(Object.new)

    assert traffic_police_mock.verify
  end

  it 'notifes when parking lot is filled 80 %' do
    parking_space1 = ParkingSpace.new 120
    parking_space2 = ParkingSpace.new 30
    traffic_police_mock = Minitest::Mock.new
    parking_lot = ParkingLot.new(parking_space1, parking_space2)
    parking_lot.add_observer traffic_police_mock
    119.times { parking_space1.park(Object.new) }
    traffic_police_mock.expect :notify_parking_almost_full, parking_lot, [parking_lot]
    parking_space2.park(Object.new)
    assert traffic_police_mock.verify
  end

  it 'notifes when parking lot is filled 80% or more' do
    parking_space1 = ParkingSpace.new 9
    traffic_police_mock = Minitest::Mock.new
    parking_lot = ParkingLot.new(parking_space1)
    parking_lot.add_observer traffic_police_mock
    7.times { parking_space1.park(Object.new) }
    traffic_police_mock.expect :notify_parking_almost_full, parking_lot, [parking_lot]
    parking_space1.park(Object.new)
    assert traffic_police_mock.verify
  end

  it 'dosent sends the notification twice when parking lot is filled 80% or more' do
    parking_space1 = ParkingSpace.new 10
    traffic_police_mock = Minitest::Mock.new
    parking_lot = ParkingLot.new(parking_space1)
    parking_lot.add_observer traffic_police_mock
    traffic_police_mock.expect :notify_parking_almost_full, parking_lot, [parking_lot]
    8.times { parking_space1.park(Object.new) }

    parking_space1.park(Object.new)

    traffic_police_mock.verify
  end

  it 'resends the notification when parking lot is refilled 80% or more ' do
    parking_space1 = ParkingSpace.new 10
    parking_lot = ParkingLot.new(parking_space1)
    traffic_police_mock = Minitest::Mock.new
    parking_lot.add_observer traffic_police_mock
    7.times { parking_space1.park(Object.new) }
    last_car = Object.new
    traffic_police_mock.expect :notify_parking_almost_full, parking_lot, [parking_lot]

    parking_space1.park(last_car)
    assert traffic_police_mock.verify
    parking_space1.unpark(last_car.object_id)
    traffic_police_mock.expect :notify_parking_almost_full, parking_lot, [parking_lot]
    parking_space1.park(Object.new)
    assert traffic_police_mock.verify
  end

  it "ensures notifies police department when blue car is parked in parking lot" do
    parking_space = ParkingSpace.new 5
    parking_lot = ParkingLot.new parking_space
    benz = 'red'
    brio = 'blue'
    ciaz = 'black'
    parking_space.park(benz)
    parking_space.park(brio)
    parking_space.park(ciaz)
  
    police = PoliceDepartment.new 
    
    expected = brio.object_id
    actual = police.notify_blue_car_parked parking_lot
    assert_equal(expected,actual)
  end
end