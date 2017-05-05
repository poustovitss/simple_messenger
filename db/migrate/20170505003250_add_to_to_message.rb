class AddToToMessage < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :to, :integer
  end
end
