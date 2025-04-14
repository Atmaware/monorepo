function addStorage(itemsToAdd) {
    return chrome.storage.local.set(itemsToAdd)
}

document.addEventListener('DOMContentLoaded', () => {
  const saveApiButton = document.getElementById('save-api-key-btn')
  const apiInput = document.getElementById('api-key')


  chrome.storage.local.get('ruminerApiKey').then(
    apiKey => {
      apiInput.value = apiKey.ruminerApiKey ?? ''
    }
  )

  saveApiButton.addEventListener('click', (e) => {
    addStorage({ "ruminerApiKey": apiInput.value })
  })

  const saveUrlButton = document.getElementById('save-api-url-btn')
  const apiUrlInput = document.getElementById('api-url')

  chrome.storage.local.get('ruminerApiUrl').then(
    url => {
      apiUrlInput.value = url.ruminerApiUrl ?? ''
    }
  )

  saveUrlButton.addEventListener('click', (e) => {
    addStorage({ "ruminerApiUrl": apiUrlInput.value })
  })


  const urlButton = document.getElementById('save-ruminer-url-btn')
  const urlInput = document.getElementById('ruminer-url')

  chrome.storage.local.get('ruminerUrl').then(
    url => {
      urlInput.value = url.ruminerUrl ?? ''
    }
  )

  urlButton.addEventListener('click', (e) => {
    addStorage({ "ruminerUrl": urlInput.value })
  })
});
