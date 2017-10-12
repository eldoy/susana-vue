import Vue from 'vue'
import Router from 'vue-router'
import store from './store'
import Home from '@/components/root/Home'
import Login from '@/components/user/Login'
import Signup from '@/components/user/Signup'
import Settings from '@/components/user/Settings'

Vue.use(Router)

const pre = {
  authorized: (to, from, next) => {
    store.state.auth ? next() : next('/login')
  },
  unauthorized: (to, from, next) => {
    store.state.auth ? next('/') : next()
  },
  blank: (to, from, next) => {
    store.commit('set', { key: 'top', val: false })
    next()
  }
}

const router = new Router({
  routes: [
    { path: '/', name: 'Home', component: Home },
    { path: '/login', name: 'Login', component: Login },
    { path: '/signup', name: 'Signup', component: Signup },
    {
      path: '/settings',
      name: 'Settings',
      component: Settings,
      beforeEnter: (to, from, next) => { pre.authorized(to, from, next) }
    }
  ],
  mode: 'history'
})

router.beforeEach((to, from, next) => {
  next()
})

export default router
