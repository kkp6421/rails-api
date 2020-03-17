import Vue from 'vue/dist/vue.esm'
import Router from './router/router'
import { BootstrapVue, BootstrapVueIcons } from 'bootstrap-vue'
import Navbar from './components/header'
import auth from './auth/auth'

import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

Vue.use(BootstrapVue)
Vue.use(BootstrapVueIcons)

var app = new Vue({
    el: '#app',
    router: Router,
    components: {
        'navbar': Navbar
    }
})
