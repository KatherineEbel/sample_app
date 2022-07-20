
document.addEventListener('turbo:load', () => {
  document.querySelector('.app-header').addEventListener('click', () => {
    let dropdownMenu
  
    const dropdownToggle = document.querySelector('.dropdown-toggle')
    if (!dropdownToggle) return
  
    const dropdownOpen = () => {
      return dropdownMenu && dropdownMenu.classList.contains('open')
    }
  
    dropdownToggle.addEventListener('click', (event) => {
      event.stopImmediatePropagation()
      dropdownMenu = document.querySelector('.dropdown-menu')
      dropdownMenu.classList.toggle('open')
      dropdownMenu.addEventListener('click', (event) => {
        event.target.classList.remove('open')
      })
    })
  
    document.body.addEventListener('click', () => {
      if (dropdownOpen()) {
        dropdownMenu.classList.remove('open')
      }
    })
  })
})