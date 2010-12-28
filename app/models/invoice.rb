class Invoice
  def self.get
    return {
      :period_month => Date.today.month-1,
      :period_year => ( Date.today-(1.month) ).year,
      :invoice_date => Date.today
    }
  end
end
