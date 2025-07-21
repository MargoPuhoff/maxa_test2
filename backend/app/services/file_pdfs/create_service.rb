class FilePdfs::CreateService
  attr_reader :file_pdf

  def initialize(params)
    @params = params
  end

  def call
    @file_pdf = FilePdf.new(file_pdf_params)

    if @file_pdf.save
      begin
        @file_pdf.convert_to_pdf

        if @file_pdf.converted_pdf.attached?
          { success: true, file_pdf: @file_pdf }
        else
          { success: false, errors: @file_pdf.errors.full_messages.presence || ["Conversion error"] }
        end
      rescue => e
        { success: false, errors: ["Conversion error: #{e.message}"] }
      end
    else
      { success: false, errors: @file_pdf.errors.full_messages }
    end
  end

  private

  def file_pdf_params
    params.require(:file_pdf).permit(:original_file)
  end
end