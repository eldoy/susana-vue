<template>
  <section class="top">
    <div class="nav-toggler">
      <a href="javascript:void(0)" @click.prevent="toggleNav"><i class="fa fa-bars"></i></a>
    </div>
    <nav v-if="loggedIn">
      <router-link to="/" active-class="active" exact>home</router-link>
      <router-link to="/settings" active-class="active" exact>settings</router-link>
      <a href="/logout" @click.prevent="logout">logout</a>
    </nav>
    <nav v-else>
      <router-link to="/" active-class="active" exact>home</router-link>
      <router-link to="/login" active-class="active" exact>login</router-link>
      <router-link to="/signup" active-class="active" exact>signup</router-link>
    </nav>
  </section>
</template>

<script>
export default {
  name: 'top',

  computed: {
    loggedIn () {
      return this.$store.state.auth
    }
  },

  methods: {
    logout () {
      this.axios.get('/api/user/logout').then((res) => {
        let r = res.data
        this.$store.dispatch('flashInfo', r.messages.join(', '))
        this.$store.commit('logout')
        this.$router.push('/')
      })
    },
    toggleNav () {
      if (this.nav) {
        document.body.className = 'menu-active'
      } else {
        document.body.className = ''
      }
      this.nav = !this.nav
    }
  },

  data () {
    return {
      nav: true
    }
  }
}
</script>
