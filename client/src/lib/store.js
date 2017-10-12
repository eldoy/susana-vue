import Vue from 'vue'
import Vuex from 'vuex'
import * as Cookies from 'js-cookie'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    auth: Cookies.get('auth'),
    error: '',
    info: ''
  },
  mutations: {
    login (state) {
      Cookies.set('auth', 1)
      state.auth = 1
    },
    logout (state) {
      Cookies.remove('auth')
      state.auth = null
    },
    flash (state, args) {
      state[args.type] = args.val
    },
    set (state, args) {
      state[args.key] = args.val
    }
  },
  actions: {
    flashError (context, val) {
      context.commit('flash', {type: 'error', val: val})
      context.dispatch('hideFlash', 'error')
    },
    flashInfo (context, val) {
      context.commit('flash', {type: 'info', val: val})
      context.dispatch('hideFlash', 'info')
    },
    hideFlash (context, type) {
      setTimeout(() => {
        context.commit('flash', {type: type, val: ''})
      }, 4000)
    },
    killFlash (context, type) {
      context.commit('flash', {type: 'info', val: ''})
      context.commit('flash', {type: 'error', val: ''})
    }
  }
})

export default store
