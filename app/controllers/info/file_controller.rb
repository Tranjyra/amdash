module Info
  class Info::FileController < ApplicationController

    before_action :set_category, only: [ :add, :index, :show, :destroy, :edit, :about]
    before_action :set_subcategory, only: [ :add, :index, :show, :destroy, :edit, :about]
    before_action :set_file, only: [ :index, :show, :destroy, :edit, :update, :about]


    def index
    end

    def show
    end

    def add
      @category_active=@category.id
      @subcategory_active=@subcategory.id
      respond_to do |format|
        format.js
      end
    end

    def create
      tempparams=params.permit(:id,:name,:desc,:source_url,:category_id,:subcategory_id,:filecustom)
      data = {}
      data[:base_type]=3
      data[:created_by]=current_user.id
      data[:updated_by]=current_user.id
      tempparams=tempparams.merge( data )

      @file = Infodb.new(tempparams)
      if @file.save
        respond_to do |format|
           format.js
        end
        redirect_to info_subcategory_path(@file.subcategory_id, :cid=>@file.category_id ), success: "Документ успешно добавлен"
      else
        clean_orphaned_blob
        redirect_back fallback_location: :back, danger: @file.errors.messages[:name].join(";")
      end
    end

    def edit
      respond_to do |format|
        format.js       
      end
    end

    def about
      @name_createdby=User.unscoped.search_by_id(@file.created_by)[0].name_short
      if @file.updated_by?
        @name_updatedby=User.unscoped.search_by_id(@file.updated_by)[0].name_short
      else
        @name_updatedby=@name_createdby
      end
      respond_to do |format|
        format.js       
      end
    end

    def update
      tempparams=params.require(:infodb).permit(:id,:name,:desc,:source_url,:filecustom)
      data = {} 
      data[:updated_by]=current_user.id
      tempparams=tempparams.merge( data )

      @file.filecustom.purge
      if @file.update(tempparams)
        respond_to do |format|
          format.js
        end
        redirect_to info_subcategory_path(@file.subcategory_id, :cid=>@file.category_id), success: "Документ обновлен"
      else
        clean_orphaned_blob
        redirect_to info_subcategory_path(@file.subcategory_id, :cid=>@file.category_id), danger: "Нет документа с таким id [при запросе документа] "+@file.errors.messages[:name].join(";")
      end

    end

    def destroy
      file_temp=@file
      @file.filecustom.purge
      if @file.destroy
        redirect_to info_subcategory_path(@subcategory.id, :cid=>@category.id), success: "Файл #{file_temp.name} успешно удалён"
      else
        clean_orphaned_blob
        redirect_back fallback_location: :back, danger: "Ошибка при удалении "
      end
    end

    def clean_orphaned_blob
      cnt=0
      errors=''
      ActiveStorage::Blob.where.not(id: ActiveStorage::Attachment.select(:blob_id)).find_each do |blob|
        blob.purge 

      end    
    end
    def info_params
      params.permit(:id,:name,:desc,:base_type,:source_url,:category_id,:subcategory_id,:created_by,:filecustom)
    end

    def set_file
      begin
        @file = Infodb.find(params[:id])
      rescue
        redirect_to info_index_path, danger: "Нет файла с таким id [при запросе файла]"
      end

    end
    def set_category
      begin
        @category = Infodb.find(params[:cid])
      rescue
        redirect_to info_index_path, danger: "Нет категории с таким id [при запросе файла]"
      end

    end

    def set_subcategory
      begin
        @subcategory = Infodb.find(params[:sid])
      rescue
        redirect_to info_index_path, danger: "Нет подкатегории с таким id [при запросе файла]"
      end
    end
  end
end
