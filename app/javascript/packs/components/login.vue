<template>
    <div class="container">
        <h1>ログイン</h1>
        <p v-if="$route.query.redirect" class="text-danger">ログインしてください。</p>
        <form @submit.prevent="login">
            <div class="form-group">
                <label>Email</label>
                <input v-model="email" placeholder="email" class="form-control">
                <div class="text-danger" v-if="!validation.email.format">メールアドレスの形式が不正です。</div>
                <div class="text-danger" v-if="!validation.email.required">メールアドレスを入力してください。</div>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" v-model="password" placeholder="password" class="form-control">
                <div class="text-danger" v-if="!validation.password.required">パスワードを入力してください。</div>
            </div>
            <button type="submit" class="btn btn-outline-success">ログイン</button>
            <br/>
            <p v-if="error" class="text-danger">ログインに失敗しました。</p>
        </form>
    </div>
</template>

<script>
    import axios from 'axios'
    import auth from '../auth/auth'
    const required = val => !!val.trim()
    const REGEX_EMAIL = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    export default {
        data: function () {
            return {
                email: '',
                password: '',
                error: false
            }
        },
        computed: {
            validation: function () {
                return {
                    email: {
                        required: required(this.email),
                        format: REGEX_EMAIL.test(this.email)
                    },
                    password: {
                        required: required(this.password)
                    }
                }
            },
        },
        methods: {
            login: function() {
                if(!this.validation.email.required){
                    alert("メールアドレスを入力してください。")
                    return
                }
                if(!this.validation.email.format){
                    alert("メールアドレスの形式が不正です。")
                    return
                }
                if(!this.validation.password.required){
                    alert("パスワードを入力してください。")
                    return
                }
                let _this = this
                auth.login(this.email, this.password, function (loggedIn) {
                    if(!loggedIn){
                        _this.error = true
                    }else{
                        _this.$router.replace(_this.$route.query.redirect || '/')
                    }
                })
            }
        }
    }
</script>

<style scoped>
    .text-danger{
        font-size: 0.6rem;
    }
</style>
