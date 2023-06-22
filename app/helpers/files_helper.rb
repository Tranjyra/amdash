module FilesHelper

  def try_show_image(image,resolution,ext="png")
    begin
      image.variant(resize: resolution, rotate: '0', auto_orient: true)
    rescue
      if ['doc', 'docx'].include? ext
        "menu/word-icon-medium.jpg"
      elsif  ['xls', 'xls','xlsx'].include? ext
        "menu/excel-icon-medium.png"
      else
        "not-available.png"
      end
    end
  end

  def try_show_preview(image,resolution)
    begin
      image.preview(resize: "300x300")
    rescue
      "not-available.png"
    end
  end






end