class TasksController < ApplicationController
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
    @task = Task.new(task_params)
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
    @task = Task.find(params[:id])
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

  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
  end

  def sort_params
    if params[:sort_deadline_on]
      { deadline_on: :asc }
    elsif params[:sort_by] == 'priority'
      { priority: :desc }
    else
      { created_at: :desc }
    end
  end
end
