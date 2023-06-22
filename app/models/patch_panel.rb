class PatchPanel < ApplicationRecord
  belongs_to :job
  has_many :ports, dependent: :destroy

  def self.init(job_id)
    @patch_panel = PatchPanel.new({job_id: job_id})
    if @patch_panel.save
      24.times do |i|
        Port.create!({patch_panel_id: @patch_panel.id, port_number: i + 1, zone_id: nil, eq_id: nil, comment: nil, used: false, empty: false, short_description: nil})
      end
      return @patch_panel
    end
    return nil
  end
end
