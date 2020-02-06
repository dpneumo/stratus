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
    .map {|line| line&.strip }
    .chunk {|line| !line.empty? }
    .map {|chunk| chunk2hash(chunk) }
    .reject {|h| h.empty? }
  end

  def chunk2hash(chunk)
    chunk.last
    .reject {|properties| properties.empty? }
    .map {|property| components(property) }
    .reject {|prop_kvpair| prop_kvpair.nil? }
    .to_h
  end

  def components(property)
    k, v = property.split(':')
    kvpair = [ k&.strip || '', v&.strip || '' ]
    (kvpair.empty? || kvpair.first.empty?) ? nil : kvpair
  end
end

