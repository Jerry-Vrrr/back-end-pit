class AddRoleAndCompanyIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :role, :string
    add_column :users, :logged_company_id, :integer
  end
end
