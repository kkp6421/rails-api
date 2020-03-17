import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'
import Index from '../components/index'
import About from '../components/about'
import Contact from '../components/contact'
import Login from '../components/login'
import CreateUser from '../components/createUser'

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
                    alert("ログインしてください。")
                }else{
                    next()
                }
            }
        },
        {
            path: '/users/new',
            component: CreateUser,
            beforeEnter: function(to, from, next){
                if(auth.loggedIn()){
                    next({
                        path: '/',
                        query: { redirect: to.fullPath }
                    })
                    alert("一旦ログアウトしてください。")
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
            component: Login,
            beforeEnter: function(to, from, next){
                if(auth.loggedIn()){
                    next({
                        path: '/',
                        query: { redirect: to.fullPath }
                    })
                    alert("ログイン済みです。")
                }else{
                    next()
                }
            }
        },
        {
            path: '/logout',
            beforeEnter: function (to, from, next) {
                if(auth.loggedIn()){
                    auth.logout()
                    next({
                        path: '/login',
                        query: { redirect: to.fullPath }
                    })
                }else{
                    next({
                        path: '/',
                        query: { redirect: to.fullPath }
                    })
                }
            }
        }
    ],
})
