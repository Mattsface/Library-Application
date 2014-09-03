class DefaultRatingToReviews < ActiveRecord::Migration
  def up
    change_column :reviews, :rating, :integer, default: 0.0
  end

  def down
    change_column :reviews, :Rating, :integer, default: nil
  end

end
