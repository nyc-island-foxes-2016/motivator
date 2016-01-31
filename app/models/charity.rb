class Charity < ActiveRecord::Base
  has_many :goals

  validates_presence_of :name , :url , :category
end
