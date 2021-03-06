class TasksController < ApplicationController
  include JsonWebToken
  before_action :jwt_authenticate

  def index
    render status: 200, json: {statue: 200, tasks: @current_user.tasks}
  end

  def create
    new_task = @current_user.tasks.build(task_params)
    if new_task.save
      render statue: 200, json: {statue: 200, new_task: new_task}
    else
      render status: 400,  json: {status: 400, msg: new_task.errors}
    end
  end

  def done
    task = Task.find(params[:id])
    if task.update(task_params)
      render statue: 200, json: {status: 200, task: task}
    else
      render statue: 400, json: {statue: 400, msg: task.errors}
    end
  end

  def task_params
    params.require(:task).permit(:content, :is_done)
  end

end
