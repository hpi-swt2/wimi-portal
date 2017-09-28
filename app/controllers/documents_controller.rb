# lib/document_builder.rb
require 'document_builder'

class DocumentsController < ApplicationController
  def generate_pdf
    if !params[:doc_type] or !params[:doc_id]
      raise ArgumentError, 'doc_type or doc_id is not set'
    else
      builder = DocumentBuilder.new(params)
      pdf = builder.build_pdf
      send_data(pdf, filename: builder.build_file_name, type: 'application/pdf')
    end
  end 
end
