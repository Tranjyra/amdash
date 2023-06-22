class PhotosController < ApplicationController
  skip_before_action :authentificate, only: [:check]
  before_action :set_photo, except: [:new, :create]
  before_action :set_job, except: [:check]

  def show1;
    respond_to do |format|
      format.html
      format.js
    end
  end
  def new
    @photo = Photo.new
    respond_to do |format|
      format.html
      format.js
    end
  end
  def create
    @photo = Photo.new(photo_params)
    if @photo.save
      respond_to do |format|
        format.html {redirect_to job_path(@job), success: "Фото успешно добавлено"}
        format.js
      end
    else
      respond_to do |format|
        format.html {redirect_back fallback_location: :back, danger: @photo.errors.full_messages}
        format.js
      end
    end
  end
  def edit; end
  def update
    @photo = @photo.update(photo_params)
    if @photo.save
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def destroy
    if @photo.destroy
      respond_to do |format|
        format.html {redirect_to job_path(@job), success: "Фото успешно удалено"}
        format.js
      end
    else
      respond_to do |format|
        format.html {redirect_to job_path(@job), danger: "Ошибка удаления #{@photo.errors.full_messages}"}
        format.js
      end
    end
  end

  def check
    if @photo.update(check_params)
      flash.now[:success] = "Успешно обновлено"
    else
      flash.now[:danger] = "Ошибка обновления"
    end
  end

  private
    def set_photo
      begin
        @photo = Photo.find(params[:id])
      rescue
        render_404
      end

    end
    def set_job
      @job = Job.find(params[:job_id])
    end
    def photo_params
      params.require(:photo).permit(:job_id, :image, :comment, :zone_id, :eq_id)
    end
    def check_params
      params.require(:photo).permit(:checked)
    end
end
