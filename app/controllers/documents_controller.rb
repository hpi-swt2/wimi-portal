class DocumentsController < ApplicationController

  def generate_pdf
      if (!params[:doc_type] or !params[:doc_id])
        raise ArgumentError, "doc_type or doc_id is not set"
      else
        self.init_params
        # WickedPDF looks for stylesheet files in app/assets/stylesheets
        @tmp_vars[:css_file] = "pdf.css"
        @tmp_vars[:hpi_logo] = "#{Rails.root}/app/assets/images/HPI-Logo.jpg"

        pdf = WickedPdf.new.pdf_from_string(render_to_string(
          'documents/'<<@doc_type<<'.html.erb',
          :layout => false,
          :locals => @tmp_vars))
        send_data(pdf, :filename => @doc_type<<'.pdf',  :type=> 'application/pdf')
      end
  end

  def init_params
      @doc_type = params[:doc_type]
      @tmp_vars = {}
      case @doc_type
      when 'Dienstreiseantrag'
        @tmp_vars[:trip] = Trip.find(params[:doc_id])
        @tmp_vars[:trip].annotation = @tmp_vars[:trip].annotation || ""
        @tmp_vars[:annotation_splitted] = @tmp_vars[:trip].annotation.split("\n")[0,4]
      when 'Urlaubsantrag'
        @tmp_vars[:holiday] = Holiday.find(params[:doc_id])
        @tmp_vars[:holiday].annotation = @tmp_vars[:holiday].annotation || ""
        @tmp_vars[:annotation_splitted] = @tmp_vars[:holiday].annotation.split("\n")
      when 'Reisekostenabrechnung'
        @tmp_vars[:report] = TravelExpenseReport.find(params[:doc_id])
        @tmp_vars[:reason_splitted] = @tmp_vars[:report].reason.split("\n")
      else
        raise NotImplementedError
      end
  end

end
