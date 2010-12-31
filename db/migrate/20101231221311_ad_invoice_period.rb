class AdInvoicePeriod < ActiveRecord::Migration
  def self.up
    add_column "invoice_school_districts", "period_start", :date
    add_column "invoice_school_districts", "period_end", :date
  end

  def self.down
    remove_column "invoice_school_districts", "period_start"
    remove_column "invoice_school_districts", "period_end"
  end
end
