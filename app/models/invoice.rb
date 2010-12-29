class Invoice

  def self.get_last_month
    return {
      :period_month => Date.today.month-1,
      :period_year => ( Date.today-(1.month) ).year,
      :invoice_date => Date.today
    }
  end

  def self.get_this_month
    return {
      :period_month => Date.today.month,
      :period_year =>  Date.today.year,
      :invoice_date => Date.today
    }
  end

  def self.get_for_month_type(month_type)
       invoice= if month_type= ==:last_month then Invoice.get_last_month else Invoice.get_this_month end
       return invoice
  end

end
