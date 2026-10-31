class AddUsernameToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :username, :string unless column_exists?(:users, :username)

    # Backfill usernames for existing users
    User.reset_column_information
    User.find_each do |user|
      next if user.username.present?

      base_handle = if user.first_name.present? && user.last_name.present?
                      "#{user.first_name}_#{user.last_name}".downcase.gsub(/[^a-z0-9_]/, '')
                    else
                      user.email.split('@').first.downcase.gsub(/[^a-z0-9_]/, '')
                    end
      base_handle = "user" if base_handle.blank?

      candidate = base_handle
      counter = 1
      while User.where(username: candidate).where.not(id: user.id).exists?
        candidate = "#{base_handle}#{counter}"
        counter += 1
      end

      user.update_column(:username, candidate)
    end

    add_index :users, :username, unique: true unless index_exists?(:users, :username)
  end

  def down
    remove_index :users, :username if index_exists?(:users, :username)
    remove_column :users, :username if column_exists?(:users, :username)
  end
end
