class CreateStays < ActiveRecord::Migration[7.2]
  def change
    create_table :stays, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.references :studio, null: false, foreign_key: true, index: true, type: :uuid
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
