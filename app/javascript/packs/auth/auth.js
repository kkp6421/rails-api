import axios from  'axios'

export default {
    login: function (email, password, cb) {
        axios.post('/api/login', {
            email: email, password: password
        }).then(response => {
            setTimeout(function () {
                localStorage.token = response.data.token
                if(cb){ cb(true) }
            }, 1000)
        }).catch(response => {
            setTimeout(function () {
                if(cb){ cb(false) }
            }, 1000)
        })
    },
    logout: function () {
        delete localStorage.token
    },
    loggedIn: function () {
        return !!localStorage.token
    }

}
