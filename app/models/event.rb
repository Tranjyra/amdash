class Event < ApplicationRecord
  serialize :serialized_subject

  enum event_type: %i[system user]

  belongs_to :user

  scope :unreaded, -> {where readed: false}

  after_create_commit { EventsBroadcastJob.perform_later self}

  def subject
    begin
      @subject ||= serialized_subject[:class_name].constantize.find serialized_subject[:id]
    rescue
      # @subject ||= serialized_subject
      @subject ||= serialized_subject[:class_name].constantize.new
    end
  end

  def from_user
    if event_type == "user"
      @from_user ||= User.find from_user_id
    else
      "System"
    end
  end
end
