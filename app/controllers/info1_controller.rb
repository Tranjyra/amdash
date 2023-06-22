class InfoController < ApplicationController



  def index


  end

  def docs

    @info = Info.all
    #@staff = @staff.where(zone_id: params[:zone_id]) if params[:zone_id]

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
        #format.html
        format.js
      end
    end

  end

  def docs_subcat_update
    @docs = Info.find(params[:id])
    if @docs.save
      respond_to do |format|
        #format.html
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
        #format.html
        format.js
      end
    end

  end

  def docs_subcat_file_update
    @docs = Info.find(params[:id])
    if @docs.save
      respond_to do |format|
        #format.html
        format.js
      end
    end
  end



  def info_params
    params.permit(:id,:name,:desc,:base_type,:source_url,:category_id,:subcategory_id,:created_by)
  end

  def help

  end

end
