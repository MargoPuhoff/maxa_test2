class FilePdfsController < ApplicationController
  before_action :set_file_pdf, only: %i[ show update destroy ]

  # GET /file_pdfs
  def index
    @file_pdfs = FilePdf.all

    render json: @file_pdfs
  end

  # GET /file_pdfs/1
  def show
    render json: @file_pdf
  end

  # POST /file_pdfs
  def create
    if params[:file_pdf].blank? || params[:file_pdf][:original_file].blank?
      render json: { error: 'File is required' }, status: :unprocessable_entity
      return
    end

    @file_pdf = FilePdf.new(file_pdf_params)

    if @file_pdf.save
      begin
        @file_pdf.convert_to_pdf

        if @file_pdf.converted_pdf.attached?
          render json: {
            id: @file_pdf.id,
            pdf_url: url_for(@file_pdf.converted_pdf),
            original_filename: @file_pdf.original_filename,
            message: 'Conversion completed'
          }, status: :created
        else
          render json: { error: 'Conversion error' }, status: :unprocessable_entity
        end

      rescue => e
        render json: { error: "Conversion error: #{e.message}" }, status: :unprocessable_entity
      end
    else
      render json: @file_pdf.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /file_pdfs/1
  def update
    if @file_pdf.update(file_pdf_params)
      render json: @file_pdf
    else
      render json: @file_pdf.errors, status: :unprocessable_entity
    end
  end

  # DELETE /file_pdfs/1
  def destroy
    @file_pdf.original_file.purge
    @file_pdf.converted_pdf.purge

    @file_pdf.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_file_pdf
      @file_pdf = FilePdf.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def file_pdf_params
      params.require(:file_pdf).permit(:original_file)
    end
end
