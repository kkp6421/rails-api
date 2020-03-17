<template>
    <div class="container">
        <br/>
        <div class="row">
            <div class="col-10 col-lg-10 col-md-10">
                <input class="form-control" placeholder="Taskを入力してください。" v-model="newTaskContent">
                <div class="text-danger" v-show="emptyError">内容を入力してください。</div>
            </div>
            <div class="col-2 col-lg-2 col-md-2">
                <b-icon icon="plus" font-scale="2.5" class="bg-danger rounded-circle text-white" v-on:click="createTask"></b-icon>
            </div>
        </div>
        <br/>
        <div class="task-list">
            <b-list-group>
                <b-list-group-item v-for="task in tasks_not_done" v-bind:id="'row_task_'+task.id" class="row_task">
                    <label v-bind:id="'task_' + task.id">
                        <input type="checkbox" v-on:change="doneTask(task.id)" v-bind:id="'task_' + task.id">{{ task.content }}
                    </label><br/>
                    作成日時:<br/>{{ formatTime(new Date(task.created_at)) }}
                </b-list-group-item>
            </b-list-group>
        </div>

        <div class="btn btn-outline-success" v-on:click="displayDoneTasks">Display done tasks</div>

        <div id="done-tasks" class="display_none task-list">
            <b-list-group>
                <b-list-group-item v-for="task in tasks_done" v-bind:id="'row_task_'+task.id" class="row_task">
                    <label v-bind:id="'task_' + task.id" class="line-through">
                        <input type="checkbox" v-bind:id="'task_' + task.id" checked="checked" disabled="disabled">{{ task.content }}
                    </label><br/>
                    終了日時:<br/>{{ formatTime(new Date(task.updated_at)) }}
                </b-list-group-item>
            </b-list-group>
        </div>
    </div>
</template>

<script>
    import auth from '../auth/auth'
    import axios from 'axios'
    export default{
        data: function () {
            return{
                tasks_not_done: [],
                tasks_done: [],
                newTaskContent: ''
            }
        },
        created: function () {
            this.fetchTask()
        },
        watch: {
            '$route': 'fetchTask'
        },
        computed: {
            emptyError: function () {
                return this.newTaskContent.trim() === ''
            }
        },
        methods: {
            fetchTask: function() {
                let _this = this
                axios.get('/api/tasks/', {
                    headers: {
                        'Authorization': `Bearer ${localStorage.token}`
                    }
                }).then(response => {
                    for (var i=0; i<response.data.tasks.length; i++){
                        if(response.data.tasks[i].is_done){
                            //完了済みTask
                            this.tasks_done.push(response.data.tasks[i])
                        }else{
                            //未完了タスク
                            this.tasks_not_done.push(response.data.tasks[i])
                        }
                    }
                    this.tasks_not_done.reverse()
                    this.tasks_done.reverse()
                }).catch(response => {
                    auth.logout()
                    _this.$router.push('/login')
                    alert("トークンの有効期限が切れました。一度ログアウトしてもう一度ログインしてください。")
                })
            },
            displayDoneTasks: function () {
                document.querySelector('#done-tasks').classList.toggle('display_none');
            },
            createTask: function () {
                let _this = this
                if(this.newTaskContent.trim() === ''){
                    alert("内容を入力してください.")
                    return
                }
                axios.defaults.headers.common["Authorization"] = `Bearer ${localStorage.token}`;
                axios.post('/api/tasks/new/', {
                    task: {content: this.newTaskContent}
                }).then(response => {
                    this.tasks_not_done.unshift(response.data.new_task);
                    this.newTaskContent = ''
                }).catch(response => {
                    _this.$router.push('/login')
                    auth.logout()
                    alert("トークンの有効期限が切れました。一度ログアウトしてもう一度ログインしてください。")
                })
            },
            doneTask: function (task_id) {
                let _this = this
                axios.defaults.headers.common["Authorization"] = `Bearer ${localStorage.token}`;
                axios.put('/api/tasks/done/'+task_id, {
                    task: {is_done: true}
                }).then(response => {
                    var task_not_done_clone = this.tasks_not_done
                    this.tasks_not_done = task_not_done_clone.filter(function(task) {
                        return task.id !== task_id;
                    })
                    this.tasks_done.unshift(response.data.task);
                }).catch(response => {
                    auth.logout()
                    _this.$router.push('/login')
                    alert("トークンの有効期限が切れました。一度ログアウトしてもう一度ログインしてください。")
                })
            },
            formatTime: function(time){
                var y = time.getFullYear()
                var mt = time.getMonth() + 1
                var date = time.getDate()
                var week = time.getDay()
                var weeks = ["日", "月", "火", "水", "木", "金", "土"];
                var w = weeks[week]
                var h = time.getHours()
                var m = time.getMinutes()
                return y+"年"+mt+"月"+date+"日"+"("+w+"曜日) "+h+"時"+m+"分"
            }
        }
    }
</script>

<style scoped>
    .text-danger{
        font-size: 0.6rem;
    }
    .display_none{
        display: none;
    }
    .line-through{
        text-decoration: line-through;
    }
    .task-list{
        padding: 9px 3px;
    }
    .rounded-circle{
        position: relative;
        bottom: 4px;
    }
    .row_task{
        padding: 8px;
    }
</style>
