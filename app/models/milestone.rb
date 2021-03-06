class Milestone < ActiveRecord::Base
  belongs_to :goal

  validates :description, presence: true
  validates :deadline, presence: true

  def update_status(user)
    if user == self.goal.setter
      self.completed = true
    else
      self.confirmed = true
    end
  end

  def announce
    if self.confirmed == true
      Message.create(
        user_id: 1,
        goal_id: self.goal_id,
        content: "#{self.goal.tender.username} has confirmed that #{self.goal.setter.username} has completed the milestone '#{self.description}'."
      )
    else
      Message.create(
        user_id: 1,
        goal_id: self.goal_id,
        content: "#{self.goal.setter.username} has reported to #{self.goal.tender.username} that the milestone '#{self.description}' is complete."
      )
    end
  end

  def is_completable_by?(user)
    self.goal.setter == user && self.completed == false
  end

  def is_confirmable_by?(user)
    self.goal.tender == user && self.completed == true && self.confirmed == false
  end

end
