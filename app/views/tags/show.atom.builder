atom_feed do |feed|
  feed.title("Limi's Sphere of Influence - #{@tag.name} Feed")
  feed.updated(@entries.first.created_at)

  @entries.each do |entry|
    feed.entry(entry) do |entry|
      entry.title(entry.title)
      entry.content(entry.content, :type => 'html')
      entry.author { |author| author.name("Limi") }
    end
  end
end