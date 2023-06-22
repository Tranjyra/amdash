class SuperviseMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  add_template_helper(ActionView::Helpers::UrlHelper)
  def supervised_photo
    @photos = params[:photos]
    return if @photos.count<1

    @emails = User.supervisers.collect(&:email).join(",")
    @store = params[:store]
    @names = []
    @photos.each do |photo|
      attachments[photo.image.blob.filename.to_s] = photo.image.blob.download
      p = photo.image.variant(resize: "600x600", rotate: '0', auto_orient: true).processed
      @names << {att_name: p.key, anotation: "#{photo.zone.name} #{photo.eq.name} #{photo.comment}".capitalize, id: photo.id}
      attachments.inline[p.key] = p.service.download(p.key)
    end
    if @store!='м-н Тестовый магазин'
      #@photos.count
      make_bootstrap_mail(to: @emails, subject: "#{subject_prepend} Фотоотчет #{@store}")
    else
      make_bootstrap_mail(to: 'zazin@gloria-jeans.ru', subject: "#{subject_prepend} Фотоотчет(тест) #{@store}  ")
    end
  end
end