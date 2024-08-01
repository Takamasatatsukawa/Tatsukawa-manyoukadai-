class TasksController < ApplicationController
  before_action :require_login
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  def index
    @search_params = search_params
    @q = params[:q]
    @label_id = params[:label_id]

    @tasks = current_user.tasks.includes(:labels)
                             .page(params[:page])
                             .per(10)
                             .sorted_by(sort_params)
                             .search_by_title(params.dig(:search, :title))
                             .search_by_status(params.dig(:search, :status))

    if @q.present?
      @tasks = @tasks.where('title LIKE ? OR description LIKE ?', "%#{@q}%", "%#{@q}%")
    end

    if @label_id.present?
      @tasks = @tasks.joins(:labels).where(labels: { id: @label_id })
    end

    if params[:search].present?
      if @search_params[:title].present? && @search_params[:status].present?
        # タイトルとステータスの両方で検索
        @tasks = @tasks.search_by_title(@search_params[:title])
                       .search_by_status(@search_params[:status])
      elsif @search_params[:label].present?
        # ラベルで検索
        @tasks = @tasks.joins(:labels).where(labels: { id: @search_params[:label] })
      end
    end

    @labels = current_user.labels
  end

  def show
  end

  def new
    @task = Task.new
    @labels = current_user.labels
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      @task.labels = Label.where(id: params[:task][:label_ids], user_id: current_user.id)
      redirect_to tasks_path, notice: t('flash.tasks.create.success')
    else
      @labels = current_user.labels
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
    @labels = current_user.labels
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      @task.labels = Label.where(id: params[:task][:label_ids], user_id: current_user.id)
      redirect_to task_path(@task), notice: t('flash.tasks.update.success')
    else
      @labels = current_user.labels
      # byebug # ここでデバッグを開始します
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t('flash.tasks.destroy.success')
  end

  private

  def set_task
    @task = current_user.tasks.find_by(id: params[:id])
    render_404 if @task.nil?
  end

  def task_params
    params.require(:task).permit(:title, :description, :deadline_on, :content, :priority, :status, label_ids: [])
  end

  def correct_user
    if @task.nil?
      flash[:notice] = "アクセス権限がありません"
      redirect_to tasks_path
    end
  end

  def sort_params
    if params[:sort_deadline_on]
      { deadline_on: :asc }
    elsif params[:sort_by] == 'priority'
      { priority: :desc, created_at: :desc }
    else
      { created_at: :desc }
    end
  end

  def search_params
    params.fetch(:search, {}).permit(:title, :status, :label)
  end
end
