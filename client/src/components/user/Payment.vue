<template>
  <div class="payment">
    <template v-if="!user">
      <div class="loader" style="padding: 0.78em 0">.: Loading :.</div>
    </template>
    <form @submit.prevent="submitForm" v-else-if="!user.paid">
      <div class="group">
        <label>
          <span>Name</span>
          <input class="field" placeholder="Jane Doe" v-model.trim="name"></input>
        </label>
        <label>
          <span>ZIP code</span>
          <input class="field" placeholder="94110" v-model.trim="zip"></input>
        </label>
      </div>
      <div class="group">
        <label>
          <span>Card</span>
          <div id="card-element" class="field"></div>
        </label>
      </div>
      <p class="buttons">
        <button class="wo-btn" :class="{ 'btn-disabled': processing }">Subscribe</button>
      </p>
    </form>
    <div class="user-paid" v-else>
      <div class="payment-info">You are subscribed.</div>
      <div class="payment-cancel">
        <a href="javascript:void(0)" @click.prevent="cancelSubscription">Cancel subscription</a>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['errors', 'success'],
  created () {
    this.axios.get('/api/user/current').then((res) => {
      this.user = res.data.result
      if (this.user && !this.user.paid) {
        setTimeout(this.initStripe, 1)
      }
    })
  },
  data () {
    return {
      complete: false,
      // Uncomment for development: stripe: window.Stripe('pk_test_JYjfAwsv9ODbL6mm1qObrIXQ'),
      stripe: window.Stripe('pk_test_JYjfAwsv9ODbL6mm1qObrIXQ'),
      card: null,
      name: '',
      zip: '',
      user: null,
      processing: false,
      testing: false
    }
  },

  methods: {
    initStripe () {
      let elements = this.stripe.elements()
      this.card = elements.create('card', {
        style: {
          base: {
            iconColor: '#666EE8',
            color: '#31325F',
            lineHeight: '40px',
            fontWeight: 300,
            fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
            fontSize: '15px',
            '::placeholder': {
              color: '#CFD7E0'
            }
          }
        }
      })
      this.card.mount('#card-element')

      // Set fake data
      if (this.testing) {
        this.name = 'Susana'
        this.zip = '12345'
      }
      this.card.on('change', (event) => {
        this.setOutcome(event)
      })
    },
    setOutcome (result) {
      this.$parent.error = null
      this.$parent.success = null

      if (result.token) {
        this.$parent.success = 'Processing payment...'
        this.axios.post('/api/payments', {
          token: result.token.id,
          name: this.name,
          zip: this.zip
        }).then((res) => {
          let r = res.data
          if (r.status === 'ok') {
            this.user.paid = true
          } else {
            this.$parent.error = r.result
          }
          this.$parent.success = null
          this.processing = false
        })
      } else if (result.error) {
        this.$parent.errors = result.error.message
        this.processing = false
      }
    },
    submitForm (e) {
      if (this.processing) {
        return false
      }
      this.processing = true
      var extraDetails = {
        name: this.name,
        address_zip: this.zip
      }
      this.stripe.createToken(this.card, extraDetails).then(this.setOutcome)
    },
    cancelSubscription () {
      if (this.processing) {
        return false
      }

      this.processing = true
      this.axios.delete('/api/payments').then((res) => {
        let r = res.data
        if (r.status === 'ok') {
          this.user.paid = false
          this.$store.dispatch('flashInfo', 'You have unsubscribed')
          setTimeout(this.initStripe, 1)
        } else {
          this.$parent.errors = r.result
        }
        this.processing = false
      })
    }
  }
}
</script>
