require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end
  describe "instance methods" do
    it "total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end
  end

    it "total_discounted_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Skin Care')


      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

      @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant2.id)
      @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant2.id)

      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @invoice_2 = Invoice.create!(customer_id: @customer_2.id, status: 2)

      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 10, unit_price: 10, status: 1)


      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 5, unit_price: 10, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_4.id, quantity: 5, unit_price: 20, status: 1)

      @bulk_discount = BulkDiscount.find_or_create_by!(name: "Discount A", percentage: 20, quantity_threshold: 10, merchant_id: @merchant1.id)
      @bulk_discount2 = BulkDiscount.find_or_create_by!(name: "Discount C", percentage: 10, quantity_threshold: 10, merchant_id: @merchant1.id)
      @bulk_discount3 = BulkDiscount.find_or_create_by!(name: "Discount D", percentage: 10, quantity_threshold: 10, merchant_id: @merchant2.id)



      expect(@invoice_1.total_discounted_revenue).to eq(160)
      expect(@invoice_2.total_discounted_revenue).to eq(150)
    end

    it "total_discounted_revenue two discounts/twoitems" do
      merchant = Merchant.create!(name: 'Eye Care')

      item_1 = Item.create!(name: "Drops", description: "Moistens dry eyes", unit_price: 10, merchant_id: merchant.id, status: 1)
      item_2 = Item.create!(name: "Contacts", description: "Helps you see", unit_price: 5, merchant_id: merchant.id)

      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

      ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 12, unit_price: 10, status: 2)
      ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 15, unit_price: 10, status: 1)

      bulk_discount = BulkDiscount.find_or_create_by!(name: "Discount A", percentage: 20, quantity_threshold: 10, merchant_id: merchant.id)
      bulk_discount2 = BulkDiscount.find_or_create_by!(name: "Discount B", percentage: 30, quantity_threshold: 15, merchant_id: merchant.id)

      expect(invoice_1.total_discounted_revenue).to eq(201)
    end

  it "total_discounted_revenue two discounts/twoitems/one discount used" do
    merchant = Merchant.create!(name: 'Dental Care')

    item_1 = Item.create!(name: "Shampoo", description: "This washes your teeth", unit_price: 10, merchant_id: merchant.id, status: 1)
    item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your teeth but in a clip", unit_price: 5, merchant_id: merchant.id)

    customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

    invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

    ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 12, unit_price: 10, status: 2)
    ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 15, unit_price: 10, status: 1)

    bulk_discount = BulkDiscount.find_or_create_by!(name: "Discount A", percentage: 20, quantity_threshold: 10, merchant_id: merchant.id)
    bulk_discount2 = BulkDiscount.find_or_create_by!(name: "Discount B", percentage: 15, quantity_threshold: 15, merchant_id: merchant.id)

    expect(invoice_1.total_discounted_revenue).to eq(216)
  end

  it "total_discounted_revenue twomerchants/two discounts/twoitems/two discount used" do
    merchant = Merchant.create!(name: 'Elbow Care')
    merchant2 = Merchant.create!(name: 'Skin Care')

    item_1 = Item.create!(name: "Shampoo", description: "This washes your elbows", unit_price: 10, merchant_id: merchant.id, status: 1)
    item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your elbow but in a clip", unit_price: 5, merchant_id: merchant.id)

    item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: merchant2.id)

    customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

    invoice_a = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

    ii_1 = InvoiceItem.create!(invoice_id: invoice_a.id, item_id: item_1.id, quantity: 12, unit_price: 10, status: 2)
    ii_2 = InvoiceItem.create!(invoice_id: invoice_a.id, item_id: item_2.id, quantity: 15, unit_price: 10, status: 1)

    ii_3 = InvoiceItem.create!(invoice_id: invoice_a.id, item_id: item_3.id, quantity: 15, unit_price: 10, status: 1)

    bulk_discount = BulkDiscount.find_or_create_by!(name: "Discount A", percentage: 20, quantity_threshold: 10, merchant_id: merchant.id)
    bulk_discount2 = BulkDiscount.find_or_create_by!(name: "Discount B", percentage: 30, quantity_threshold: 15, merchant_id: merchant.id)

    expect(invoice_a.total_discounted_revenue).to eq(351)
  end
end
