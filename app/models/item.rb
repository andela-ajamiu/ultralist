class Item < ApplicationRecord
  belongs_to :bucketlist

  validates :name, presence: true, uniqueness: true
end
