<template>
  <div id="app">
    <Top></Top>
    <section class="content">
      <section class="view">
        <div class="flash">
          <div class="flash-e">{{ flashError }}</div>
          <div class="flash-i">{{ flashInfo }}</div>
        </div>
        <transition name="component-fade" mode="out-in">
          <router-view></router-view>
        </transition>
      </section>
    </section>
  </div>
</template>

<script>
import Top from './components/layout/Top'

export default {
  name: 'app',
  components: {Top},
  computed: {
    flashError () {
      return this.$store.state.error
    },
    flashInfo () {
      return this.$store.state.info
    }
  }
}
</script>

<style lang="scss">
@import 'assets/css/grid.scss';
@import 'assets/css/app.scss';
@import 'assets/css/screen.scss';
@import 'assets/css/server.scss';
@import 'assets/css/settings.scss';
@import 'assets/css/loader.scss';
@import 'assets/css/home.scss';
@import 'assets/css/top.scss';
@import 'assets/css/flash.scss';
@import 'assets/css/payment.scss';
@import 'assets/css/switcher.scss';
@import 'assets/css/responsive.scss';
</style>
