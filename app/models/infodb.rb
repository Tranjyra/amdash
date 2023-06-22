class Infodb < ApplicationRecord
   belongs_to :user , foreign_key: :created_by

   has_one_attached :filecustom

   validate :file_validation

   def file_validation

     if filecustom.attached?
       if filecustom.blob.byte_size > 31457280 #30Mb
         filecustom.purge
         self.errors.add(:name,"Файл превышает допустимый размер")
       #elsif !filecustom.blob.content_type.starts_with?('image/')
         #filecustom.purge
         #self.errors.add(:name,"Формат не поддерживается")
       end
     end
   end


end
