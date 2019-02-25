class ParseVbManageList
# Expects a list (array) structured like this:

# [
#   "Name:          Mark\n",
#   "Age:           45\n",
#   "Sex:           Male\n",
#   "FavoriteColor: Green\n",
#   "\n",
#   "Name:          Ruby\n",
#   "Age:           25\n",
#   "Sex:           Female\n",
#   "FavoriteColor: Red\n",
#   "\n"
# ]

  def parse(list)
    list
    .map {|pair| clean(pair) }
    .chunk {|pair| !!pair }
    .select {|chunk| chunk[0] }
    .map {|chunk| chunk2hash(chunk[1]) }
    .reject {|h| h.empty? }
  end

  def clean(txt)
    cleaned = txt&.strip
    cleaned&.empty? ? nil : cleaned
  end

  def chunk2hash(items)
    items
    .reject {|item| item.empty? }
    .map {|item| components(item) }
    .reject {|item| item.empty? || item.first.empty? }
    .to_h
  end

  def components(pair)
    k, v = pair.split(':')
    [ k&.strip || '', v&.strip || '' ]
  end
end
