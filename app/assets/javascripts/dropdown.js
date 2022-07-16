const header = document.querySelector('.app-header')
// let dropdownToggle, dropdownMenu
let dropdownMenu

const dropdownToggle = document.querySelector('.dropdown-toggle')

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