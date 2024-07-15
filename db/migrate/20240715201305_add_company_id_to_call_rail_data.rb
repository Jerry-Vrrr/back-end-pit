class AddCompanyIdToCallRailData < ActiveRecord::Migration[7.1]
  def change
    add_column :call_rail_data, :company_id, :string
  end
end
