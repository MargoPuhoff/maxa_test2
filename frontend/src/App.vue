<script setup>
  import { ref } from 'vue'

  const selectedFile = ref(null)
  const isUploading = ref(false)
  const uploadStatus = ref('')
  const uploadedFile = ref(null)

  const handleFileSelect = (event) => {
  const file = event.target.files[0]
  if (file) {
    const maxSize = 10 * 1024 * 1024
    if (file.size > maxSize) {
      uploadStatus.value = 'File size must be less than 10MB'
      return
    }

    if (!file.name.toLowerCase().endsWith('.svg')) {
      uploadStatus.value = 'Please select an SVG file'
      return
    }

    selectedFile.value = file
    uploadStatus.value = ''
  }
}

  const handleSubmit = async () => {
    console.log('handleSubmit')

    if (!selectedFile.value) {
      uploadStatus.value = 'Please select a file first'
      return
    }

    isUploading.value = true
    uploadStatus.value = 'Uploading...'

    try {
      const formData = new FormData()
      formData.append('file_pdf[original_file]', selectedFile.value)

      const response = await fetch('http://localhost:3000/file_pdfs', {
        method: 'POST',
        body: formData
      })

      if (response.ok) {
        const contentDisposition = response.headers.get('Content-Disposition')
        let filename = 'converted.pdf'
        if (contentDisposition) {
          const filenameMatch = contentDisposition.match(/filename="(.+)"/)
          if (filenameMatch) {
            filename = filenameMatch[1]
          }
        }

        // Скачивание файла
        const blob = await response.blob()
        const url = window.URL.createObjectURL(blob)
        const a = document.createElement('a')
        a.href = url
        a.download = filename
        document.body.appendChild(a)
        a.click()
        window.URL.revokeObjectURL(url)
        document.body.removeChild(a)

        uploadStatus.value = 'File uploaded and converted successfully! PDF downloaded.'
        selectedFile.value = null
      } else {
        const errorData = await response.json()
        uploadStatus.value = `Upload failed: ${errorData.error || 'Unknown error'}`
      }
    } catch (error) {
      console.error('Upload error:', error)
      uploadStatus.value = 'Upload failed. Please try again.'
    } finally {
      isUploading.value = false
    }
  }

  const clearForm = () => {
    selectedFile.value = null
    uploadStatus.value = ''
  }
</script>

<template>
  <div class="app">
    <div class="container">
      <h1>File Upload</h1>

      <div class="upload-form">
        <div class="file-input-container">
          <input
            id="file-input"
            type="file"
            accept=".svg"
            @change="handleFileSelect"
            class="file-input"
          />
          <label for="file-input" class="select-button">
            Select File
          </label>
          <div v-if="selectedFile" class="selected-file">
            {{ selectedFile.name }}
          </div>
        </div>

        <div class="form-actions">
          <button
            @click="handleSubmit"
            :disabled="!selectedFile || isUploading"
            class="upload-button"
            :class="{ 'uploading': isUploading }"
          >
            <span v-if="isUploading" class="loading-spinner"></span>
            {{ isUploading ? 'Uploading...' : 'Upload File' }}
          </button>

          <button
            @click="clearForm"
            :disabled="!selectedFile && !uploadStatus"
            class="clear-button"
          >
            Clear
          </button>
        </div>

        <div v-if="uploadStatus" class="status-message" :class="{ 'success': uploadStatus.includes('successfully'), 'error': uploadStatus.includes('failed') || uploadStatus.includes('Please select') }">
          {{ uploadStatus }}
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
  .app {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f5f5;
}

.container {
  padding: 2rem;
  max-width: 400px;
  width: 100%;
  border-radius: 8px;
  background: white;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

h1 {
  margin-bottom: 1.5rem;
  font-weight: 500;
  text-align: center;
  font-size: 1.5rem;
  color: #333;
}

.upload-form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.file-input-container {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.file-input {
  display: none;
}

.select-button {
  padding: 0.75rem 1.5rem;
  font-size: 1rem;
  font-weight: 500;
  text-align: center;
  cursor: pointer;
  color: white;
  background: #28a745;
  border: none;
  border-radius: 4px;
  transition: background-color 0.2s ease;
}

.select-button:hover {
  background: #218838;
}

.selected-file {
  padding: 0.5rem;
  font-size: 0.9rem;
  border-radius: 4px;
  border: 1px solid #dee2e6;
  color: #495057;
  background: #f8f9fa;
}

.form-actions {
  display: flex;
  justify-content: center;
  gap: 0.5rem;
}

.upload-button, .clear-button {
  padding: 0.75rem 1.5rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  border: none;
  border-radius: 4px;
  transition: all 0.2s ease;
}

.upload-button {
  color: white;
  background: #007bff;
}

.upload-button:hover:not(:disabled) {
  background: #0056b3;
}

.upload-button:disabled {
  cursor: not-allowed;
  background: #ccc;
}

.upload-button.uploading {
  background: #007bff;
}

.clear-button {
  color: white;
  background: #6c757d;
}

.clear-button:hover:not(:disabled) {
  background: #545b62;
}

.clear-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.status-message {
  padding: 0.75rem;
  text-align: center;
  font-weight: 500;
  border-radius: 4px;
  font-size: 0.9rem;
}

.status-message.success {
  border: 1px solid #c3e6cb;
  color: #155724;
  background: #d4edda;
}

.status-message.error {
  border: 1px solid #f5c6cb;
  color: #721c24;
  background: #f8d7da;
}

.loading-spinner {
  width: 1rem;
  height: 1rem;
  border: 2px solid transparent;
  border-top: 2px solid white;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

@media (max-width: 600px) {
  .container {
    padding: 1.5rem;
    margin: 1rem;
  }

  .form-actions {
    flex-direction: column;
  }

  .upload-button, .clear-button {
    width: 100%;
    justify-content: center;
  }
}
</style>
