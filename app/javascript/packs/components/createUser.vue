<template>
    <div class="container">
        <form @submit.prevent="createUser">
            <div class="form-group">
                <label>name</label>
                <input type="text" v-model="name" class="form-control" placeholder="name">
                <div v-show="!this.validation.name.required" class="text-danger">ユーザーネームを入力してください。</div>
            </div>
            <div class="form-group">
                <label>email</label>
                <input type="email" v-model="email" class="form-control" placeholder="email">
                <div v-show="!this.validation.email.required" class="text-danger">メールアドレスを入力してください。</div>
                <div v-show="!this.validation.email.format" class="text-danger">メールアドレスの形式が不正です。</div>
            </div>
            <div class="form-group">
                <label>password(min-length: 6)</label>
                <input type="password" v-model="password" class="form-control" placeholder="password">
                <div v-show="!this.validation.password.required" class="text-danger">パスワードを入力してください。</div>
                <div v-show="!this.validation.password.length" class="text-danger">パスワードの文字数が足りません。</div>
            </div>
            <div class="form-group">
                <label>password_confirm</label>
                <input type="password" v-model="password_confirmation" class="form-control" placeholder="password_confirmation">
                <div v-show="!this.validation.password_confirmation.required" class="text-danger">確認用パスワードを入力してください。</div>
                <div v-show="!this.validation.password_confirmation.match" class="text-danger">パスワードと違います。</div>
            </div>
            <button type="submit" class="btn btn-outline-success">ユーザー作成</button>
            <div class="text-danger" v-if="error" style="position: relative; top: 8px;">ユーザーを作成できません。</div>
        </form>
    </div>
</template>

<script>
    import axios from 'axios'
    const required = val => !!val.trim()
    const REGEX_EMAIL = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    export default {
        data: function () {
            return {
                error: false,
                name: '',
                email: '',
                password: '',
                password_confirmation: ''
            }
        },
        computed: {
            validation: function () {
                return {
                    name: {
                        required: required(this.name)
                    },
                    email: {
                        required: required(this.email),
                        format: REGEX_EMAIL.test(this.email)
                    },
                    password: {
                        required: required(this.password),
                        length: this.password.length >= 6
                    },
                    password_confirmation: {
                        required: required(this.password_confirmation),
                        match: this.password.trim() === this.password_confirmation.trim()
                    }
                }
            },
        },
        methods: {
            createUser: function () {
                if(!this.validation.name.required){
                    alert("名前を入力してください。")
                    return
                }
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
                if(!this.validation.password_confirmation.required){
                    alert("確認パスワードを入力してください。")
                    return
                }
                if(!this.validation.password_confirmation.match){
                    alert("確認パスワードとパスワードと違います。")
                    return
                }
                axios.defaults.headers.common["Authorization"] = `Bearer ${localStorage.token}`;
                axios.post('/api/users/new/', {
                    user: {name: this.name, email: this.email, password: this.password, password_confirmation: this.password_confirmation }
                }).then(response => {
                    this.$router.push('/login')
                }).catch(response => {
                    this.error = true
                    console.log(response)
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
