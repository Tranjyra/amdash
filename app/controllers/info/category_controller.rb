module Info
  class Info::CategoryController < ApplicationController

    before_action :set_category, only: [:index, :show, :destroy, :edit, :update]

  def index
    @categories=Infodb.where(base_type:1)
    @category_active=@category.id
    @subcategories=Infodb.where(category_id:@category.id,base_type:2)
    render('index')
  end

  def getcount;
    Infodb.where(base_type:1).count
  end

  def show
    index
  end

  def add
    @category=nil

    respond_to do |format|
      format.js
    end
  end

  def create
        tempparams=params.permit(:id,:name,:desc)
    data = {}  
    data[:base_type]=1
    data[:category_id]=0
    data[:subcategory_id]=0
    data[:created_by]=current_user.id    
    tempparams=tempparams.merge( data )
    @category = Infodb.new(tempparams)
       if @category.save
           respond_to do |format|
        format.js
      end
      redirect_to info_index_path, success: "Категория успешно добавлена"
    else
      redirect_back fallback_location: :back, danger: params[:name]
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    tempparams=params.require(:infodb).permit(:id,:name,:desc)
    data = {}
    data[:updated_by]=current_user.id
    tempparams=tempparams.merge( data )

    if @category.update(tempparams)
      respond_to do |format|
        format.js
      end
      redirect_to info_index_path, success: "Категория обновлена"
    else
      redirect_to info_index_path, danger: "Нет категории с таким id [при запросе категории]"
    end

  end


  def is_empty
    Infodb.where(category_id:@category.id).count<1
  end

  def destroy

    cat_temp=@category

    if not is_empty
      redirect_to info_category_path(@category.id), danger: "Категория #{cat_temp.name} имеет вложения, сперва необходимо удалить их"
      return
    end

    if @category.destroy
      redirect_to info_index_path, success: "Категория #{cat_temp.name} успешно удалена"
    end
  end

  def info_params
    params.require(:infodb).permit(:id,:name,:desc,:base_type,:source_url,:category_id,:subcategory_id,:created_by)
  end

  def set_category
    begin
      @category = Infodb.find(params[:id])
    rescue
      redirect_to info_index_path, danger: "Нет категории с таким id [при запросе категории]"
    end

  end

  def docs
    @info = Info.all 
  end

  def docs_add_subcat;
    respond_to do |format|
      format.js
      format.html
    end
  end

  def docs_subcat_create
    @docs = Info.new(info_params)

    if @docs.save
      respond_to do |format|    
        format.js
      end
    end

  end

  def docs_subcat_update
    @docs = Info.find(params[:id])
    if @docs.save
      respond_to do |format|       
        format.js
      end
    end
  end

  def docs_add_subcat_file;
    respond_to do |format|
      format.js
      format.html
    end
  end

  def docs_subcat_file_create
    @docs = Info.new(info_params)

    if @docs.save
      respond_to do |format|      
        format.js
      end
    end

  end

  def docs_subcat_file_update
    @docs = Info.find(params[:id])
    if @docs.save
      respond_to do |format|
            format.js
      end
    end
  end
  def help
  end
  end
end
