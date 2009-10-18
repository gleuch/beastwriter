class AddBrainBuster < ActiveRecord::Migration
  def self.up
    create_table "brain_busters", :force => true do |t|
      t.string "question"
      t.string "answer"
    end

   # create "Wieviel ist zwei und zwei?", "4"
   # create "Was ist die Zahl vor zwölf?", "11"
   # create "Wieviel ist 5 mal 2?", "10"
   # create "Geben Sie die nächste Nummer der Sequenz ein: 10, 11, 12, 13, 14, ??", "15"
   # create "Wieviel ist fünf mal fünf?", "25"
   # create "10 durch 2 ist wieviel?", "5"
   # create "Welcher Tag kommt nach Montag?", "Dienstag"
   # create "Was ist der letzte Montag des Jahres?", "Dezember"
   # create "Wieviele Minuten hat eine Stunde?", "60"
   # create "Was ist das Gegenteil von unten?", "oben"
   # create "Was liegt Gegenüber von Norden?", "Süden"
   # create "Was ist das Gegenteil von böse?", "gut"
   # create "Bitte Kinderlied vervollständigen: 'Alle meine ???", "Entchen"
   # create "Wieviel ist vier mal 4?", "16"
   # create "Welche Nummer kommt vor zweiundzwanzig?", "21"
   # create "Welcher Monat kommt vor Juli?", "Juni"
   # create "Wieviel ist fünfzehn durch drei?", "5"
   # create "Wieviel ist vierzehn minus vier?", "10"
   # create "Was folgt? 'Montag, Dienstag, Mittwoch, ???'", "Donnerstag"
  end

  def self.down
    drop_table "brain_busters"
  end

  # create a logic captcha - answers should be lower case
  #def self.create(question, answer)
  #  BrainBuster.create(:question => question, :answer => answer.downcase)
  #end
end
