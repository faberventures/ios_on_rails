class V1::TasksController < ApplicationController
  before_filter :authenticate_v1_user!

  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = current_v1_user.tasks
    render json: @tasks
  end

  def create
    @task = current_v1_user.tasks.create(task_params)

    if @task
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:title, :completed, :user_id)
  end
end
