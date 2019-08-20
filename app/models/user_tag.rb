class UserTag < ApplicationRecord
  acts_as_sortable do |config|
    config[:append] = true
    config[:relation] = ->(instance) {instance.user.user_tags.where(status: instance.status) }
  end

  belongs_to :user
  belongs_to :pull_request

  enum status: { active: 0, complete: 1 }

  def update_status!(new_status)
    return if new_status == self.status

    self.send(:sortable_shift_on_destroy)
    self.status = new_status
    self.position = nil
    self.send(:sortable_set_default_position)
    self.save!
  end
end
