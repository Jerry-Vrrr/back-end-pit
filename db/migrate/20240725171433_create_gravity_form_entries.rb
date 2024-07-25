class CreateGravityFormEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :gravity_form_entries do |t|
      t.string :company_id
      t.string :form_id
      t.string :entry_id
      t.datetime :date_created
      t.string :name
      t.string :phone
      t.string :email
      t.text :message
      t.string :source_url

      t.timestamps
    end
  end
end
