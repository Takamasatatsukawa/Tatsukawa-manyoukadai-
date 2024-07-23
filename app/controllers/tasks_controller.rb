class TasksController < ApplicationController
  before_action :require_login
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.page(params[:page]).per(10)
                  # .default_order
                  .sorted_by(sort_params)
                  .search_by_title(params.dig(:search, :title))
                  .search_by_status(params.dig(:search, :status))
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path(@task.id), notice: t('flash.tasks.create.success')
    else
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = @task.update(task_params)
    if @task.update(task_params)
      redirect_to @task, notice: t('flash.tasks.update.success')
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: t('flash.tasks.destroy.success')
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
  end

  
  # def correct_user
  #   @task = Task.find(params[:id])
  #   unless current_user == @task.user
  #     flash[:notice] = "アクセス権限がありません"
  #     redirect_to(tasks_path)
  #   end
  # end

  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    if @task.nil?
      flash[:notice] = "アクセス権限がありません"
      redirect_to tasks_path
    end
  end

  def sort_params
    if params[:sort_deadline_on]
      { deadline_on: :asc }
    elsif params[:sort_by] == 'priority'
      { priority: :desc, created_at: :desc  }
    else
      { created_at: :desc }
    end
  end
end
