class ParseVagrantList
# Expects a list (array) structured like this:

# [
#   "Name:          Mark\n"
#   "Age:           45\n"
#   "Sex:           Male\n"
#   "FavoriteColor: Green\n"
#   "\n"
#   "Name:          Ruby\n"
#   "Age:           25\n"
#   "Sex:           Female\n"
#   "FavoriteColor: Red\n"
#   "\n"
# ]

  def parse(list)
    list
    .map {|pair| clean(pair) }
    .chunk {|pair| !!pair }
    .select {|chunk| chunk[0] }
    .map {|chunk| chunk2ifc(chunk[1]) }
  end

  private
    def clean(pair)
      cleaned = pair&.strip
      cleaned.empty? ? nil : cleaned
    end

    def chunk2ifc(pairs)
      pairs
      .map {|pair| components(pair) }
      .to_h
    end

    def components(pair)
      return if pair.nil? || pair.empty?
      k, v = pair.split(':')
      [ k&.strip, v&.strip ]
    end
end
