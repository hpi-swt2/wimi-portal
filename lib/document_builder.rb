class DocumentBuilder < ActionController::Base

  def initialize(params)
    init_params(params)
  end
  
  def build_pdf
    # WickedPDF looks for stylesheet files in app/assets/stylesheets
    @tmp_vars[:css_file] = 'document.css'
    @tmp_vars[:hpi_logo] = "#{Rails.root}/app/assets/images/HPI-Logo.jpg"

    pdf = WickedPdf.new.pdf_from_string(
      render_to_string(
        "documents/#{@doc_type}.html.erb",
        layout: false,
        locals: @tmp_vars
      )
    )

    return pdf
  end
  
  def build_file_name
    if @doc_type == 'Timesheet'
      file_name = @tmp_vars[:timesheet].attachment_name
    else
      file_name = @doc_type
    end
    file_name + '.pdf'
  end

  private
  
  def init_params(params)
    @doc_type = params[:doc_type]
    @tmp_vars = {}
    case @doc_type
    when 'Timesheet'
      @tmp_vars[:timesheet] = TimeSheet.find(params[:doc_id])
      @tmp_vars[:days_in_month] = []
      @tmp_vars[:work_days] = @tmp_vars[:timesheet].work_days
      @tmp_vars[:include_comments] = params[:include_comments] == '1'
      # First day of month
      day = Date.new(@tmp_vars[:timesheet].year, @tmp_vars[:timesheet].month)
      # Iterate over all days for this month
      while day.month == @tmp_vars[:timesheet].month
        @tmp_vars[:days_in_month].push({
          date: day, start: ' ', break: ' ', end: ' ',
          duration: '0:00', notes: ' '
        })
        day += 1 # Select following day
      end
      for workday in @tmp_vars[:timesheet].work_days do
        for day in @tmp_vars[:days_in_month] do
          if workday.date == day[:date]
            day[:start] = workday.start_time.strftime('%H:%M')
            break_minutes = workday.break % 60
            break_hours = (workday.break - break_minutes) / 60
            day[:break] = format("%d:%02d", break_hours, break_minutes)
            day[:end] = workday.end_time.strftime('%H:%M')
            day[:duration] = workday.duration_hours_minutes
            day[:notes] = workday.notes
            day[:status] = workday.status
          end
        end
      end
      @tmp_vars[:sum] = @tmp_vars[:timesheet].sum_minutes_formatted
    else
      raise NotImplementedError
    end
  end
end
