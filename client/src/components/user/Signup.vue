<template>
  <div>
    <section class="dialog">
      <section class="signup">
        <h2>Signup</h2>
        <form @submit.prevent="createUser">
          <p>
            <label>
              Email
              <br>
              <input type="email" v-model.trim="user.email">
              <span class="field-error">{{ errors.email | join }}</span>
            </label>
          </p>
          <p>
            <label>
              Password
              <br>
              <input type="password" v-model.trim="user.password">
              <span class="field-error">{{ errors.password | join }}</span>
            </label>
          </p>
          <p>
            <label>
              Confirm
              <br>
              <input type="password" v-model.trim="user.confirm">
              <span class="field-error">{{ errors.confirm | join }}</span>
            </label>
          </p>
          <p>
            <button class="wo-btn">Sign up</button>
          </p>
        </form>
      </section>
    </section>
    <p>
      Already have an account?
      <router-link class="margin-left" to="/login">Log in</router-link>
    </p>
  </div>
</template>

<script>
  export default {
    name: 'signup',
    methods: {
      createUser () {
        this.axios.post('/api/user/create', {
          email: this.user.email || '',
          password: this.user.password || '',
          confirm: this.user.confirm || ''
        }).then((res) => {
          let r = res.data
          console.log(r)
          if (r.status === 'error') {
            this.$store.dispatch('flashError', r.messages.join(', '))
            this.errors = r.result
          } else {
            this.$store.commit('login')
            this.$router.push('/')
          }
        })
      }
    },
    data () {
      return {
        user: {},
        errors: {}
      }
    }
  }
</script>
