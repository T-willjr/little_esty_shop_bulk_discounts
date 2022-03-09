class HolidaySearchFacade

  def holiday_information
    service.holidays.map do |data|
      Holiday.new(data)
    end
  end

  def service
    HolidayService.new
  end
end
