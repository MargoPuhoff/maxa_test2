class FilePdfSerializer < ActiveModel::Serializer
  attributes :id, :original_filename, :message

  def message
    'Conversion completed'
  end
end