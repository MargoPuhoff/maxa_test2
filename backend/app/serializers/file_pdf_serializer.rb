class FilePdfSerializer < ActiveModel::Serializer
  attributes :id, :pdf_url, :original_filename, :message

  def pdf_url
    url_for(object.converted_pdf)
  end

  def message
    'Conversion completed'
  end
end