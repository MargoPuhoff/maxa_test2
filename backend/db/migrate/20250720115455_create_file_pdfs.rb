class CreateFilePdfs < ActiveRecord::Migration[7.2]
  def change
    create_table :file_pdfs do |t|
      t.string :original_filename

      t.timestamps
    end
  end
end
