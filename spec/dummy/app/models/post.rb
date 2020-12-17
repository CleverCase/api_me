# frozen_string_literal: true

class Post < ActiveRecord::Base
  belongs_to :user
  has_many :post_tags
  has_many :tags, through: :post_tags

  def to_csv
    [id, name]
  end

  def csv_headers
    ['id', 'name']
  end
end
