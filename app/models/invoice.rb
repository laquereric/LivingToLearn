class Invoice

  def self.get_last_last_month
    return {
      :period_month => ( Date.today-(2.month) ).month,
      :period_year => ( Date.today-(2.month) ).year,
      :invoice_date => Date.today
    }
  end

  def self.get_last_month
    return {
      :period_month => ( Date.today-(1.month) ).month,
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
       invoice = case month_type
         when :last_last_month : get_last_last_month
         when :last_month : get_last_month
         when :this_month : get_this_month
       end
       return invoice
  end

end
