# frozen_string_literal: true

class CreateMediaTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :media_types do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
