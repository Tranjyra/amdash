module Admin
  class Admin::StaffsController < AdminController
    before_action :admin?, except: [:index]
    before_action :set_staff, only: [:show, :edit, :update]
    def index
      @staffs = Staff.all
      @staffs = @staffs.name_search(params[:search]) if params[:search] && !params[:search].empty?
      respond_to do |format|
        format.html
        format.js
      end
    end

    def new;
      @staff = Staff.new
      respond_to do |format|
        format.js
        format.html
      end
    end
    def show; end
    def edit
      respond_to do |format|
        format.js
        format.html
      end
    end

    def create
      @staff = Staff.new(staff_params)
      if @staff.save
        respond_to do |format|
          format.html
          format.js
        end
      end
    end
    def update
      if @staff.update(staff_params)
        respond_to do |format|
          format.js
          format.html
        end
      end
    end
    private
    def staff_params
      params.require(:staff).permit(:name, :staff_type, :zone_id, :required, :supervised)
    end
    def set_staff
      @staff = Staff.find(params[:id])
    end
  end
end

