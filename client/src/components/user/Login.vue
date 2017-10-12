<template>
  <div>
    <section class="dialog">
      <section class="login">
        <h2>Login</h2>
        <form @submit.prevent="loginUser">
          <p>
            <label>
              Email
              <br>
              <input type="email" v-model.trim="email">
            </label>
          </p>
          <p>
            <label>
              Password
              <br>
              <input type="password" v-model.trim="password">
            </label>
          </p>
          <p>
            <button class="wo-btn">Log in</button>
          </p>
        </form>
      </section>
    </section>
    <p>
      Don't have an account yet?
      <router-link class="margin-left" to="/signup" id="page-link">Sign up</router-link>
    </p>
  </div>
</template>

<script>
  export default {
    name: 'login',
    methods: {
      loginUser () {
        this.axios.post('/api/user/login', {
          email: this.email, password: this.password
        }).then((res) => {
          let r = res.data
          if (r.status === 'error') {
            this.$store.dispatch('flashError', r.messages.join(', '))
          } else {
            this.$store.commit('login')
            this.$router.push('/')
          }
        })
      }
    },
    data () {
      return {
        email: '',
        password: ''
      }
    }
  }
</script>
