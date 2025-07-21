require "test_helper"

class FilePdfsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @file_pdf = file_pdfs(:one)
  end

  test "should get index" do
    get file_pdfs_url, as: :json
    assert_response :success
  end

  test "should create file_pdf" do
    assert_difference("FilePdf.count") do
      post file_pdfs_url, params: { file_pdf: {} }, as: :json
    end

    assert_response :created
  end

  test "should show file_pdf" do
    get file_pdf_url(@file_pdf), as: :json
    assert_response :success
  end

  test "should update file_pdf" do
    patch file_pdf_url(@file_pdf), params: { file_pdf: {} }, as: :json
    assert_response :success
  end

  test "should destroy file_pdf" do
    assert_difference("FilePdf.count", -1) do
      delete file_pdf_url(@file_pdf), as: :json
    end

    assert_response :no_content
  end
end
