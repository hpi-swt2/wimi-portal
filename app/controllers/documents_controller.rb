class DocumentsController < ApplicationController

  def generate_pdf
      if (!params[:doc_type] or !params[:doc_id])
        raise ArgumentError, "doc_type or doc_id is not set (e.g. for doc_type 'Dienstreiseantrag')"
      else
        self.init_params
        # WickedPDF looks for stylesheet files in Rails.root/public
        @tmp_vars[:css_file] = "/../app/views/documents/styles.css"
        @tmp_vars[:hpi_logo] = "#{Rails.root}/app/views/documents/img/HPI-logo.jpg"

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
      else
        raise NotImplementedError
      end
  end

end