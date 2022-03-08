require './lib/holiday'
require './lib/holiday_service'
require 'pry'

class HolidaySearch

  def holiday_information
    service.holidays.map do |data|
      Holiday.new(data)
    end
  end

  def service
    HolidayService.new
  end
end
