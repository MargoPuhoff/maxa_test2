require 'rails_helper'

RSpec.describe FilePdf, type: :model do
  describe 'associations' do
    it { should have_one_attached(:original_file) }
    it { should have_one_attached(:converted_pdf) }
  end

  describe 'attributes' do
    it { should respond_to(:original_filename) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:file_pdf)).to be_valid
    end

    it 'has a valid factory with converted pdf' do
      expect(build(:file_pdf_with_converted_pdf)).to be_valid
    end

    it 'is invalid without file' do
      file_pdf = FilePdf.new
      expect(file_pdf).not_to be_valid
      expect(file_pdf.errors[:original_file]).to include('must be attached')
    end
  end

  describe '#convert_to_pdf' do
    let(:file_pdf) { create(:file_pdf) }

    context 'when file is not SVG format' do
      let(:file_pdf) { build(:file_pdf) }

      before do
        file_pdf.original_file.attach(
          io: StringIO.new("This is not an SVG file"),
          filename: 'test.txt',
          content_type: 'text/plain'
        )
      end

      it 'adds error for non-SVG file' do
        expect {
          file_pdf.convert_to_pdf
        }.to throw_symbol(:abort)

        expect(file_pdf.errors[:base]).to include("File must be in SVG format")
      end
    end

    context 'when rsvg-convert command fails' do
      let(:file_pdf) { create(:file_pdf) }

      before do
        allow(file_pdf).to receive(:system).and_return(false)
        allow(file_pdf).to receive(:`).and_return("rsvg-convert: error: invalid SVG")
      end

      it 'adds conversion error' do
        expect {
          file_pdf.convert_to_pdf
        }.to throw_symbol(:abort)

        expect(file_pdf.errors[:base]).to include("Error converting SVG to PDF: Convert error: rsvg-convert: error: invalid SVG")
      end
    end
  end

  describe 'file validation' do
    context 'with valid SVG file' do
      let(:file_pdf) { create(:file_pdf) }

      it 'accepts SVG content type' do
        expect(file_pdf.original_file.content_type).to eq('image/svg+xml')
      end

      it 'accepts SVG filename' do
        expect(file_pdf.original_file.filename.to_s).to end_with('.svg')
      end
    end
  end

  describe 'database operations' do
    it 'can be saved to database' do
      file_pdf = build(:file_pdf)
      expect { file_pdf.save! }.not_to raise_error
    end

    it 'can be retrieved from database' do
      file_pdf = create(:file_pdf)
      retrieved_file_pdf = FilePdf.find(file_pdf.id)
      expect(retrieved_file_pdf).to eq(file_pdf)
    end
  end

  describe 'timestamps' do
    let(:file_pdf) { create(:file_pdf) }

    it 'sets created_at timestamp' do
      expect(file_pdf.created_at).to be_present
    end

    it 'sets updated_at timestamp' do
      expect(file_pdf.updated_at).to be_present
    end
  end
end
