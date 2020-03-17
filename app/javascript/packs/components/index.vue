<template>
    <div class="container">
        <br/>
        <div class="row">
            <div class="col-9 col-lg-10 col-md-10">
                <input class="form-control" placeholder="Taskを入力してください。" v-model="newTaskContent">
                <div class="text-danger" v-show="emptyError">内容を入力してください。</div>
            </div>
            <div class="col-3 col-lg-2 col-md-2">
                <b-icon icon="plus" font-scale="3" class="bg-danger rounded-circle text-white" v-on:click="createTask"></b-icon>
            </div>
        </div>
        <br/>
        <h1>未完了Task</h1>
        <div class="task-list">
            <b-list-group>
                <b-list-group-item v-for="task in tasks_not_done" v-bind:id="'row_task_'+task.id" class="row_task">
                    <input type="checkbox" v-on:change="doneTask(task.id)" v-bind:id="'task_' + task.id">
                    <label v-bind:id="'task_' + task.id">{{ task.content }}&nbsp;{{ new Date(task.created_at) }}</label>
                </b-list-group-item>
            </b-list-group>
        </div>

        <div class="btn btn-outline-success" v-on:click="displayDoneTasks">Display done tasks</div>

        <div id="done-tasks" class="display_none task-list">
            <b-list-group>
                <b-list-group-item v-for="task in tasks_done" v-bind:id="'row_task_'+task.id" class="row_task">
                    <input type="checkbox" v-bind:id="'task_' + task.id" checked="checked" disabled="disabled">
                    <label class="line-through" v-bind:id="'task_' + task.id">{{ task.content }}&nbsp;{{ new Date(task.updated_at) }}</label>
                </b-list-group-item>
            </b-list-group>
        </div>
    </div>
</template>

<script>
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
                    console.log(response)
                })
            },
            displayDoneTasks: function () {
                document.querySelector('#done-tasks').classList.toggle('display_none');
            },
            createTask: function () {
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
                    console.log(response)
                })
            },
            doneTask: function (task_id) {
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
        bottom: 5px;
    }
    .row_task{
        padding: 8px;
    }
</style>
