<template>
  <section class="settings">
    <section class="dialog">
      <h2>Settings</h2>
      <div class="switcher-container">
        <span class="switcher">
          <a :class="{'switcher-off': switcher === 'profile'}" href="javascript:void(0)" @click="switcher = 'profile'">profile</a>
          <span class="switcher-separator"> | </span>
          <a :class="{'switcher-off': switcher === 'password'}" href="javascript:void(0)" @click="switcher = 'password'">password</a>
          <span class="switcher-separator"> | </span>
          <a :class="{'switcher-off': switcher === 'payments'}" href="javascript:void(0)" @click="switcher = 'payments'">payments</a>
        </span>
      </div>

      <form @submit.prevent="updateProfile" v-if="switcher === 'profile'">
        <div class="group">
          <label>
            <span>Email</span>
            <input class="field" type="email" placeholder="Email address" v-model.trim="user.email"></input>
          </label>
        </div>
        <p class="buttons">
          <button class="wo-btn">Save</button>
        </p>
      </form>

      <form @submit.prevent="updatePassword" v-else-if="switcher === 'password'">
        <div class="group">
          <label>
            <span>Current</span>
            <input class="field" type="password" placeholder="Current Password" v-model.trim="user.current_password"></input>
          </label>
        </div>
        <div class="group">
          <label>
            <span>New</span>
            <input class="field" type="password" placeholder="New Password" v-model.trim="user.password"></input>
          </label>
          <label>
            <span>Confirm</span>
            <input class="field" type="password" placeholder="Confirm Password" v-model.trim="user.confirm"></input>
          </label>
        </div>
        <p class="buttons">
          <button class="wo-btn">Save</button>
        </p>
      </form>

      <template v-else>
        <Payment :errors="errors" :success="success"></Payment>
      </template>

      <div class="outcome">
        <div class="error" role="alert" v-if="errors">{{ errors | join }}</div>
        <div class="success" v-if="success">{{ success }}</div>
      </div>
    </section>
  </section>
</template>
<script>
import Payment from './Payment'
export default {
  components: { Payment },
  created () {
    this.axios.get(`/api/user/current`).then((res) => {
      this.user = res.data.result
    })
  },
  watch: {
    errors () {
      this.timeout('errors')
    },
    success () {
      this.timeout('success')
    }
  },
  methods: {
    timeout (what) {
      if (this[what]) {
        setTimeout(() => {
          this[what] = null
        }, 3000)
      }
    },
    updateProfile () {
      this.axios.put(`/api/user/update`, {
        email: this.user.email || ''
      }).then((res) => {
        let r = res.data
        if (r.status === 'error') {
          this.errors = r.result
        } else {
          this.errors = null
          this.success = res.data.messages.join(', ')
        }
      })
    },
    updatePassword () {
      this.axios.put(`/api/user/password`, {
        current_password: this.user.current_password || '',
        password: this.user.password || '',
        confirm: this.user.confirm || ''
      }).then((res) => {
        let r = res.data
        if (r.status === 'error') {
          this.errors = r.result
        } else {
          this.errors = null
          this.success = res.data.messages.join(', ')
        }
      })
    }
  },
  data () {
    return {
      user: {},
      errors: null,
      success: null,
      switcher: 'profile'
    }
  }
}
</script>
