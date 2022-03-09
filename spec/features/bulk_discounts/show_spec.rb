require 'rails_helper'

RSpec.describe 'Bulk Discount Show Page' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Skin Care')

    @bulk_discount = BulkDiscount.create!(name: "Discount A", percentage: 20, quantity_threshold: 10, merchant_id: @merchant1.id)
    @bulk_discount2 = BulkDiscount.create!(name: "Discount B", percentage: 30, quantity_threshold: 15, merchant_id: @merchant1.id)
    @bulk_discount3 = BulkDiscount.create!(name: "Discount C", percentage: 35, quantity_threshold: 25, merchant_id: @merchant1.id)

    visit merchant_dashboard_index_path(@merchant1)
  end

  it "displays bulk discount information on show page" do
    click_on("View all Discounts")
    click_on(@bulk_discount.name)

    expect(current_path).to eq("/merchant/#{@merchant1.id}/#{@bulk_discount.id}")

    expect(page).to have_content(@bulk_discount.name)
    expect(page).to have_content(@bulk_discount.percentage)
    expect(page).to have_content(@bulk_discount.quantity_threshold)
    expect(page).to_not have_content(@bulk_discount2.name)
    expect(page).to_not have_content(@bulk_discount3.name)
  end
end
