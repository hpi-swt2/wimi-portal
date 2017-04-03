class MigrateIncludeComments < ActiveRecord::Migration

  def up
    say_with_time "Set time sheet download prefs default to 'always ask'" do
      # Set the default enum value.
      # https://apidock.com/rails/ActiveRecord/ConnectionAdapters/SchemaStatements/change_column_default
      change_column_default(:users, :include_comments, User.include_comments['ask'])

      counter = 0
      User.all.each do |user|
        user.update(include_comments: :ask)
        counter += 1
      end
      # If the result returned is an Integer, output includes a message
      # about the number of rows in addition to the elapsed time.
      counter
    end
  end

  def down
    say_with_time "Drop time sheet download prefs default" do
      # Drop the default enum value
      # https://apidock.com/rails/ActiveRecord/ConnectionAdapters/SchemaStatements/change_column_default
      change_column_default(:users, :include_comments, nil)

      counter = 0
      User.all.each do |user|
        user.update(include_comments: nil)
        counter += 1
      end
      # If the result returned is an Integer, output includes a message
      # about the number of rows in addition to the elapsed time.
      counter
    end
  end
end
