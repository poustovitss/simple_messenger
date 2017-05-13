class ChangeReadColumnInMessages < ActiveRecord::Migration[5.0]
  def up
    change_column :messages, :read, :boolean, null: false, default: false
  end

  def down
    change_column :messages, :read, :boolean, default: false
  end
end
