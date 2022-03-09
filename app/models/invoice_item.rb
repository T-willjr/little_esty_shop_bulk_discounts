class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end


  def best_discount(total, elgible_discounts)
    discount = elgible_discounts
    .order(percentage: :desc)
    .limit(1)
    .pluck(:percentage)[0]

    percent = discount.to_f / 100

    total * percent
  end
end
