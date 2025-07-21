class FilePdf < ApplicationRecord
  require 'mini_magick'

  has_one_attached :original_file
  has_one_attached :converted_pdf

  validate :original_file_presence

  def original_file_presence
    errors.add(:original_file, 'must be attached') unless original_file.attached?
  end

  def convert_to_pdf
    return unless original_file.attached?

    # Check file is svg
    unless original_file.content_type == 'image/svg+xml' || original_file.filename.to_s.downcase.end_with?('.svg')
      errors.add(:base, "File must be in SVG format")
      throw(:abort)
    end

    temp_svg = Tempfile.new(['input', '.svg'], binmode: true)
    temp_pdf = Tempfile.new(['output', '.pdf'], binmode: true)

    begin
      # Save original file to temp file
      svg_content = original_file.download

      temp_svg.write(svg_content)
      temp_svg.rewind

      result = system("rsvg-convert #{temp_svg.path} -f pdf -o #{temp_pdf.path}") # --dpi-x=300 --dpi-y=300

      unless result
        error_output = `rsvg-convert #{temp_svg.path} -f pdf -o #{temp_pdf.path} 2>&1`
        raise "Convert error: #{error_output}"
      end

      converted_pdf.attach(
        io: File.open(temp_pdf.path),
        filename: "#{original_file.filename.base}.pdf",
        content_type: 'application/pdf'
      )

      update(original_filename: original_file.filename.to_s)

    rescue => e
      errors.add(:base, "Error converting SVG to PDF: #{e.message}")
      throw(:abort)
    ensure
      temp_svg.close
      temp_svg.unlink
      temp_pdf.close
      temp_pdf.unlink
    end
  end
end
