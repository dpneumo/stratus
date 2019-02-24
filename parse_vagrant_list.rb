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
    .map {|chunk| chunk2hash(chunk[1]) }
  end

  private
    def chunk2hash(pairs)
      pairs
      .map {|pair| components(pair) }             .tap {|x| puts x.inspect }
      .reject {|kvpair| kvpair&.first.nil? }      .tap {|x| puts x.inspect }
      .to_h
    end

    def components(pair)
      return unless pair && !pair.empty?
      k, v = pair.split(':')
      [clean(k), v&.strip || '']
    end

    def clean(txt)
      cleaned = txt&.strip
      cleaned&.empty? ? nil : cleaned
    end
end
