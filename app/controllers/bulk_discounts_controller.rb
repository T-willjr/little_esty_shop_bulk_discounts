class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:bulk_discount_id])
  end

  def new
    @merchant = Merchant.find(params[:id])
  end

  def create
    merchant = Merchant.find(params[:id])
    bulk_discount = merchant.bulk_discounts.create(discount_params)
    redirect_to merchant_bulk_discounts_path(merchant.id)
  end

  private

  def discount_params
    params.permit(:name, :percentage, :quantity_threshold)
  end
end
