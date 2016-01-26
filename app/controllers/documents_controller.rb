class DocumentsController < ApplicationController
  def generate_pdf
    if !params[:doc_type] or !params[:doc_id]
      raise ArgumentError, 'doc_type or doc_id is not set'
    else
      init_params
      # WickedPDF looks for stylesheet files in app/assets/stylesheets
      @tmp_vars[:css_file] = 'document.css'
      @tmp_vars[:hpi_logo] = "#{Rails.root}/app/assets/images/HPI-Logo.jpg"

      pdf = WickedPdf.new.pdf_from_string(render_to_string(
                                            'documents/' << @doc_type << '.html.erb',
        layout: false,
        locals: @tmp_vars))
      send_data(pdf, filename: @doc_type << '.pdf',  type: 'application/pdf')
    end
  end

  def init_params
    @doc_type = params[:doc_type]
    @tmp_vars = {}
    case @doc_type
    when 'Trip_request'
      @tmp_vars[:trip] = Trip.find(params[:doc_id])
      @tmp_vars[:trip].annotation = @tmp_vars[:trip].annotation || ''
      @tmp_vars[:annotation_splitted] = @tmp_vars[:trip].annotation.split("\n")[0, 4]
    when 'Holiday_request'
      @tmp_vars[:holiday] = Holiday.find(params[:doc_id])
    when 'Expense_request'
      @tmp_vars[:report] = Expense.find(params[:doc_id])
      @tmp_vars[:reason_splitted] = @tmp_vars[:report].reason.split("\n")
    when 'Timesheet'
      @tmp_vars[:timesheet] = TimeSheet.find(params[:doc_id])
      @tmp_vars[:days_in_month] = []
      @tmp_vars[:work_days] = @tmp_vars[:timesheet].work_days
      @tmp_vars[:sum] = 0
      # First day of month
      day = Date.new(@tmp_vars[:timesheet].year, @tmp_vars[:timesheet].month)
      # Iterate over all days for this month
      while day.month == @tmp_vars[:timesheet].month do
        @tmp_vars[:days_in_month].push({
          date: day, start: ' ', break: ' ', end: ' ',
          duration: '0:00', attendance: ' ', notes: ' '
        })
        day += 1 # Select following day
      end
      for workday in @tmp_vars[:timesheet].work_days do
        @tmp_vars[:sum] += (workday.duration * 60).to_i
        for day in @tmp_vars[:days_in_month] do
          if workday.date == day[:date] then
            day[:start] = workday.start_time.strftime("%H:%M")
            day[:break] = workday.break.to_s
            day[:end] = workday.end_time.strftime("%H:%M")
            day[:duration] = workday.duration.to_i.to_s + ":" + sprintf('%02d', workday.duration * 60 % 60)
            day[:attendance] = workday.attendance[0..0]
            day[:notes] = workday.notes[0..25]
          end
        end
      end
      @tmp_vars[:sum] = (@tmp_vars[:sum] / 60).to_s + ":" + sprintf('%02d', (@tmp_vars[:sum] % 60).to_s)
    else
      raise NotImplementedError
    end
  end
end
