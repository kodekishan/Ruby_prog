# frozen_string_literal: true

require_relative 'subject'

class ParkingStaff
  include Subject
  attr_reader :observers
  def initialize
    @observers = []
  end

  protected

  def direct
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
