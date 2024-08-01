class LabelsController < ApplicationController
  before_action :set_label, only: [:edit, :update, :destroy]
  def index
    @labels = current_user.labels
  end

  def new
    @label = current_user.labels.build
  end

  def edit
    @label = Label.find(params[:id])
  end

  def create
    @label = current_user.labels.build(label_params)
    if @label.save
      redirect_to labels_path, notice: 'ラベルを登録しました'
    else
      render :new
    end
  end

  def update
    @label = Label.find(params[:id])
    if @label.update(label_params)
      redirect_to labels_path, notice: 'ラベルを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @label = Label.find(params[:id])
    @label.destroy
    redirect_to labels_path, notice: 'ラベルを削除しました'
  end

  private

  def set_label
    @label = current_user.labels.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:name)
  end
end
