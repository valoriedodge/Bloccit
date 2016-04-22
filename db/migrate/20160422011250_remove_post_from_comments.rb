class RemovePostFromComments < ActiveRecord::Migration
  def up
      remove_reference :comments, :post
  end
  
  def down
      add_reference :comments, :post, index: true, foreign_key: true
  end
end
