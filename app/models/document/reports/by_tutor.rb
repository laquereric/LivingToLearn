class Document::Reports::ByTutor < Document::Reports::TableTemplate

  def self.next_row( row , col , page  )
    rows_per_column = 3
    row += 1
    if row < rows_per_column
      return row , col , page
    else
      return self.next_col( row , col , page )
    end
  end

  def self.next_col( row , col , page )
    self.save_cell(  col , row , page )
    row = 0
    if col >= 6 then
      col = 0
      page += 1
    else
      col += 1
    end
    return row , col , page
  end

#####################################
# Send Client Data to Cell
######################################
  def self.client_data(client,&block)
                if  client[:last_consumed_hour] and client[:last_consumed_hour].is_a? Fixnum
                  total_consumed_hours += client[:last_consumed_hour]
                end
                yield :client_data, client.prep_line(6)
                yield :client_data, client.last_attended_line(8)
                #yield :client_data, client.attendance_line(8)
                yield :client_data, client.updated_line(8)
                #yield :client_data, client.phone_line(8)
                plh = client.phone_line_hash()
#p plh
                 #yield :client_data, client.result_line(8) if rt == :other
                yield :client_data, plh[:prompt_string]
                pns = plh[:value_string].split(' ')
#p pns
                yield :client_data, pns[0] if pns[0]
                yield :client_data, pns[1] if pns[1]
                yield :client_data, pns[2] if pns[2]

                yield :client_data, client.address_line_1 if client.address_line_1
                yield :client_data, client.address_line_2 if client.address_line_2
                yield :client_data, client.city if client.city
                yield :client_data, client.state if client.state
                yield :client_data, client.zip if client.zip

                yield :client_data, client.sched_a if client.sched_a
                yield :client_data, client.sched_b if client.sched_b

                yield :client_data, client.grade_line(8)
                yield :client_data, client.origin_line(8)
                #yield client.invoice_hrs_line(month,year,8)
                yield :client_data, client.representative_line(8)
                if ( ch = client.contract_hours_line(8) )
                  yield :client_data, ch
                end
                if ( cial = client.invoice_audit_line(8) )
                  yield :client_data, cial
                end
                if ( ctl = client.tutor_line(8) )
                  yield :client_data, ctl
                end
                if ( mol = client.materials_only_line(8) )
                  yield :client_data, mol
                end
  end

  def self.get_page_data( target_service_location, &block)

    last_primary_tutor_id = nil

    Appointment::Recurring.all_at_service_location( target_service_location ).each{ |appointment|
      primary_tutor = Person::Employee.find_by_mnemonic( appointment.appointable.primary_tutor )
      primary_tutor_id = if primary_tutor.nil?
        p "No Primary Tutor assigned for #{appointment.appointable_type} #{appointment.appointable_id}"
        nil
      else
        primary_tutor.appointable_id
      end
      yield( :tutor, primary_tutor,appointment ) if last_primary_tutor_id.nil? or primary_tutor_id != last_primary_tutor_id
      yield( :appointment,appointment)

      last_primary_tutor_id = primary_tutor_id

    }

  end

#########################
#
###########################
  def self.report( target_service_location )

    result= nil
    col = 0
    row = 0
    Prawn::Document.generate("by_tutor.pdf") do |pdf|
    #Prawn::Document.generate("#{filename}.pdf") do |pdf|
      first_page = true
      get_page_data( target_service_location ) { |type_obj|
#p type_obj.inspect
        if type_obj[0] == :tutor
           tutor = type_obj[1]
           appointment = type_obj[2]
           if !first_page
             self.move_saved_to_page( pdf, self.get_current_page_data, !first_page ){ |tag,data,pdf|
               if tag == :header_lines
                 pdf.font_size = 12
                 data.each{ |header_line|
                   pdf.text header_line , :style => :bold
                 }
               end
             }
           else
             first_page = false
           end
           col = 0
           row = 0
           self.header_lines= []
           self.header_lines<< "#{tutor.last_name}, #{tutor.first_name}" if tutor
           self.header_lines<< " location #{appointment.loc}"
           self.header_lines<< " day_of_week: #{appointment.day_of_week}"
        end
        if type_obj[0] == :appointment
          appointment = type_obj[1]
          client = appointment.appointable
p "row #{row.inspect}, col #{col.inspect}"
          self.save_cell( col , row , client )
          row , col , page = self.next_row( row , col , page )
        end
        #Document::Reports::BySchool.move_saved_to_page(pdf,page_data,!first_page)
        #first_page = false
      }
      self.move_saved_to_page( pdf, self.get_current_page_data , true )
    end
    return []

  end

end
