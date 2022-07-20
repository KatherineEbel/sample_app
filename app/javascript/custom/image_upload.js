document.addEventListener('turbo:load', () => {
  document.addEventListener('change', (event) => {
    let image_upload = document.querySelector('#micropost_image')
    if (!image_upload) return
    const size_in_megabytes = image_upload.files[0].size
    if (size_in_megabytes > 5) {
      alert("Maximum file size is 5MB. Please choose a smaller file.")
      image_upload.value = ""
    }
  })
})