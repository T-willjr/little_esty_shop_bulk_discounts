class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, 'in progress', :complete]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_discounted_revenue
    merchants.group(:id).where('bulk_discount.quantity_threshold = ?', '10')
    array = invoice_items.joins(item: :bulk_discounts).where('quantity >= bulk_discounts.quantity_threshold').group(:id)
    check_and_apply(array)
  end

  def check_and_apply(array)
    if array.nil?
      total_revenue
    else
      money_saved = 0
      array.each do |invoice_item|
        elgible_discounts = invoice_item.item.bulk_discounts.where('? >= quantity_threshold', invoice_item.quantity)
        
        total = invoice_item.quantity * invoice_item.unit_price
        money_saved += invoice_item.best_discount(total, elgible_discounts)
      end
    end
    total_revenue - money_saved
  end
end
