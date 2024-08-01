class AddUserIdToLabelsWithDefault < ActiveRecord::Migration[6.1]
  def up
    # Add the column without the NOT NULL constraint
    add_reference :labels, :user, foreign_key: true

    # Set a default user_id for existing labels (assuming user_id 1 exists)
    # Adjust this as necessary for your application
  end

  def down
    remove_reference :labels, :user, foreign_key: true
  end
end
