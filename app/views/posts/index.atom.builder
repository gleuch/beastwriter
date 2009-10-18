atom_feed do |feed|
  feed.title("Limi's Sphere of Influence")
  feed.updated(@posts.first.created_at)

  @posts.each do |post|
    feed.entry(post) do |entry|
      entry.title(post.title)
      entry.content(post.content, :type => 'html')
      entry.author { |author| author.name("Limi") }
    end
  end
end