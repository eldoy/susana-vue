import Vue from 'vue'

Vue.filter('join', (obj) => {
  if (!obj) { return obj }
  let array = []

  if (obj.constructor === Object) {
    for (let key in obj) {
      if (obj.hasOwnProperty(key)) {
        array.push(key.replace(/_/g, ' ') + ' ' + obj[key])
      }
    }
  } else if (obj.constructor === String) {
    array = [obj]
  } else {
    array = obj
  }

  return array.join(', ')
})

Vue.filter('pluralize', (count, word, text) => {
  if (count === 1) {
    return text ? word : `${count} ${word}`
  } else {
    return text ? `${word}s` : `${count} ${word}s`
  }
})

export default Vue
