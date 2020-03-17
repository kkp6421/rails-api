import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'
import Index from '../components/index'
import About from '../components/about'
import Contact from '../components/contact'
import Login from '../components/login'

import auth from '../auth/auth'

Vue.use(VueRouter)

export default new VueRouter({
    mode: 'history',
    routes: [
        {
            path: '/',
            component: Index,
            beforeEnter: function(to, from, next){
                if(!auth.loggedIn()){
                    next({
                        path: '/login',
                        query: { redirect: to.fullPath }
                    })
                }else{
                    next()
                }
            }
        },
        {
            path: '/about',
            component: About
        },
        {
            path: '/contact',
            component: Contact
        },
        {
            path: '/login',
            component: Login
        },
        {
            path: '/logout',
            beforeEnter: function (to, from, next) {
                auth.logout()
                next({
                    path: '/login',
                    query: { redirect: to.fullPath }
                })
            }
        }
    ],
})
