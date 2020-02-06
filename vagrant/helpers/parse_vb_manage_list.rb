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
# with delimiter: ":"

  attr_reader :delimiter
  def initialize(delimiter: ":")
    @delimiter = delimiter
  end

  def parse(list)
    list
    .chunk {|line| line != "\n" }
    .select {|not_empty, _| not_empty }
    .map {|_,properties| props2hash(properties) }
    .reject {|h| h.empty? }
  end

  def props2hash(properties)
    properties
    .map {|property| components(property) }
    .select {|pair| pair }
    .to_h
  end

  def components(property)
    pair = get_kv(property)
    (pair.size == 1 || pair.first.empty?) ? nil : pair
  end

  def get_kv(property)
    property
    .split(delimiter,2)
    .map {|element| clean element }
  end

  def clean(element)
    element&.strip || ''
  end
end
