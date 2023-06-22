module Info
  class InfoController < ApplicationController

    def index;
      @categories=Infodb.where(base_type:1)
      render('index')
    end



  end
end
