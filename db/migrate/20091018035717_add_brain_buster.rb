class AddBrainBuster < ActiveRecord::Migration
  def self.up
    create_table :brain_busters, :force => true do |t|
      t.string :question
      t.string :answer
    end
  end

  def self.down
    drop_table :brain_busters
  end

end
