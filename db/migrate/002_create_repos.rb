class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :owner
      t.string :full_name
      t.string :name
    end
  end
end