require './lib/holiday_search'

class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @holidays = HolidaySearch.new
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:bulk_discount_id])
  end
end
