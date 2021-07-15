import '../stylesheets/application'
const images = require.context('../images', true)

import Chart from 'chart.js/auto'

import LocalTime from 'local-time'
LocalTime.start()

import Alpine from 'alpinejs'
window['Alpine'] = Alpine
Alpine.start()
