class Add2ndInvoiceFieldToInvoice < ActiveRecord::Migration

  def self.up
    add_column :invoice_school_districts, :second_invoice_line, :boolean
  end

  def self.down
    remove_column :invoice_school_districts, :second_invoice_line, :boolean
  end
end
