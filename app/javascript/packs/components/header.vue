<template>
    <div>
        <b-navbar toggleable="lg" type="dark" variant="dark">
            <b-navbar-brand href="#">Task Manager</b-navbar-brand>

            <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

            <b-collapse id="nav-collapse" is-nav>
                <b-navbar-nav>
                    <b-nav-item>
                        <router-link to="/">Tasks</router-link>
                    </b-nav-item>
                    <b-nav-item>
                        <router-link to="/about">About</router-link>
                    </b-nav-item>
                    <b-nav-item>
                        <router-link to="/contact">Contact</router-link>
                    </b-nav-item>
                </b-navbar-nav>

                <!-- Right aligned nav items -->
                <b-navbar-nav class="ml-auto" right>
                    <b-nav-item>
                        <router-link to="/logout">Logout</router-link>
                    </b-nav-item>
                    <b-nav-item>
                        <router-link to="/users/new">Create User</router-link>
                    </b-nav-item>
                </b-navbar-nav>
            </b-collapse>
        </b-navbar>
    </div>
</template>

<script>
    import auth from '../auth/auth'
    export default {
        data: function () {
            return{
                auth: auth
            }
        }
    }
</script>

<style scoped>
    body {
        min-height: 75rem;
    }
</style>
