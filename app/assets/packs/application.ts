import '../stylesheets/application'
const images = require.context('../images', true)

import LocalTime from 'local-time'
LocalTime.start()

import Alpine from 'alpinejs'
window['Alpine'] = Alpine
Alpine.start()
