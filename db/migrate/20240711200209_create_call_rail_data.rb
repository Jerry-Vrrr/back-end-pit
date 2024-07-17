class CreateCallRailData < ActiveRecord::Migration[7.1]
  def change
    create_table :call_rail_data do |t|
      t.boolean :answered
      t.string :business_phone_number
      t.string :customer_city
      t.string :customer_country
      t.string :customer_name
      t.string :customer_phone_number
      t.string :customer_state
      t.string :direction
      t.integer :duration
      t.string :call_id
      t.string :recording
      t.integer :recording_duration
      t.string :recording_player
      t.datetime :start_time
      t.string :tracking_phone_number
      t.boolean :voicemail

      t.timestamps
    end
  end
end
