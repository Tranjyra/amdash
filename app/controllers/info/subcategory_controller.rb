module Info
  class Info::SubcategoryController < ApplicationController

    before_action :set_category, only: [:add, :index, :show, :destroy, :edit]
    before_action :set_subcategory, only: [:index, :show, :destroy, :edit, :update]
    
    def index
      @categories=Infodb.where(base_type:1)
      @category_active=@category.id

      @subcategories=Infodb.where(category_id:@category.id,base_type:2)
      @subcategory_active=@subcategory.id

      @files=Infodb.where(subcategory_id:@subcategory.id,base_type:3).order('name asc')

      tempparams=params.permit(:of)
      if tempparams.has_key?(:of) && !tempparams[:of].blank?
          @filetoshow=tempparams[:of]
      end

      render('index')
    end

    def show
      index
    end

    def add
      @category_active=@category.id

      respond_to do |format|
        format.js
        #format.html
      end
    end

    def create
      tempparams=params.permit(:id,:name,:desc,:category_id)


      # Проверяем, есть ли такая категория вообще, к которой будет привязана подкатегория
      if Infodb.where(params[:category_id]).count<1
        respond_to do |format|
          format.js
        end
        redirect_to request.referrer, danger: "Целевая категория не найдена (#{params[:category_id]})"
        return
      end

      #Дополняем данными
      data = {}
      data[:base_type]=2
      data[:subcategory_id]=0
      data[:created_by]=current_user.id
      tempparams=tempparams.merge( data )

      @subcategory = Infodb.new(tempparams)

      if @subcategory.save
        respond_to do |format|
          format.js
        end
        redirect_to info_category_path(@subcategory.category_id), success: "Подкатегория успешно добавлена"
      end
    end

    def edit
      #@category_active=@category.id
      respond_to do |format|
        format.js
        #format.html
      end
    end

    def update
      tempparams=params.require(:infodb).permit(:id,:name,:desc)
      data = {}  #= data = Hash.new
      data[:updated_by]=current_user.id
      tempparams=tempparams.merge( data )

      if @subcategory.update(tempparams)
        respond_to do |format|
          format.js
        end
        redirect_to info_category_path(@subcategory.category_id), success: "Подкатегория обновлена"
      else
        redirect_to info_index_path, danger: "Нет подкатегории с таким id [при запросе подкатегории]"
      end

    end

    def is_empty
      Infodb.where(subcategory_id:@subcategory.id,base_type:3).count<1
    end

    def destroy

      subcat_temp=@subcategory

      if not is_empty
        redirect_to info_subcategory_path(@subcategory.id, :cid=>@category.id), danger: "Подкатегория #{subcat_temp.name} имеет вложения, сперва необходимо удалить их"
        return
      end

      if @subcategory.destroy
        redirect_to info_category_path(@category.id), success: "Подкатегория #{subcat_temp.name} успешно удалена"
      end
    end

    def info_params
      params.permit(:id,:name,:desc,:base_type,:source_url,:category_id,:subcategory_id,:created_by,:of)
    end

    def set_category
      begin
        @category = Infodb.find(params[:cid])
      rescue
        redirect_to info_index_path, danger: "Нет категории с таким id [при запросе подкатегории]"
      end

    end

    def set_subcategory
      begin
        @subcategory = Infodb.find(params[:id])
      rescue
        redirect_to info_index_path, danger: "Нет подкатегории с таким id [при запросе подкатегории]"
      end

    end

  end

end
