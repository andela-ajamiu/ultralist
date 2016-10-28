class Bucketlist < ApplicationRecord
  belongs_to :user
  has_many :items

  validates :name, presence: true, uniqueness: true

  def self.paginate_and_search(query_params)
    paginate(query_params[:page], query_params[:limit]).search(query_params[:q])
  end

  def self.paginate(page, limit)
    limit = default_limit(limit.to_i)
    page_no = [page.to_i, 1].max - 1
    limit(limit).offset(limit * page_no)
  end

  def self.default_limit(limit)
    limit = 20 if limit.zero?
    limit = 100 if limit > 100
    limit
  end

  def self.search(name)
    name = name.downcase if name
    where("lower(name) like ?", "%#{name}%")
  end
end
