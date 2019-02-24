require_relative '../parse_vagrant_list'
require 'test/unit'

class TestParseVagrantList < Test::Unit::TestCase
  def setup
    @pvl = ParseVagrantList.new
  end

  def test_parse_returns_an_array_of_hashes
    persons = @pvl.parse(two_persons)
    assert_equal Array, persons.class
    assert_equal Hash, persons.first.class
    assert_equal '25', persons.last['Age']
  end

  def test_can_parse_one_person
    person = @pvl.parse(one_person).first
    assert_equal 'Mark', person['Name']
  end

  def test_can_parse_person_with_gerascophobia
    person = @pvl.parse(gerascophobic).first
    assert_equal 'Jack', person['Name']
    assert_equal '', person['Age']
  end

  def test_parse_removes_empty_hashes
    persons = @pvl.parse(empty_persons_included)
    assert_equal Array, persons.class
    assert_equal Hash, persons.first.class
    assert_equal '25', persons.last['Age']
  end

# Tests of private methods
  # ------ clean ------
  def test_clean_removes_extraneous_leading_and_trailing_whitespace
    mystr   = "\t Name:          Mark  \t\n"
    cleaned =    "Name:          Mark"
    assert_equal cleaned, @pvl.send(:clean, mystr)
  end

  def test_clean_returns_nil_for_a_solo_return
    assert_equal nil, @pvl.send(:clean, "\n")
  end

  # ------ components ------
  def test_components_splits_string_into_kv_pair_removing_white_space
    mystr = "Name  :          Mark"
    assert_equal ['Name', 'Mark'], @pvl.send(:components, mystr)
  end

  def test_components_returns_empty_string_for_a_value_that_is_empty
    mystr = "Name:   "
    assert_equal ['Name', ''], @pvl.send(:components, mystr)
  end

  def test_components_returns_nil_for_an_empty_pair
    mystr = ""
    assert_equal nil, @pvl.send(:components, mystr)
  end

  # ------ chunk2hash ------
  def test_chunk2hash_maps_a_chunk_of_string_pairs_to_a_hash
    mychunk = one_person_chunk
    myhash  = @pvl.send(:chunk2hash, mychunk)
    assert_equal 'Green', myhash['FavoriteColor']
  end

  def test_chunk2hash_returns_an_empty_hash_if_given_an_empty_array
    mychunk = []
    myhash  = @pvl.send(:chunk2hash, mychunk)
    assert_equal Hash, myhash.class
    assert myhash.empty?
  end

  def test_chunk2hash_removes_bad_string_pairs_before_returning_its_hash
    mychunk = [ "a: b", "", " : ", "d: ", " :g"]
    expected = {'a'=>'b','d'=>''}
    assert_equal expected, @pvl.send(:chunk2hash, mychunk)
  end

  private
    def one_person
      [
        "Name:          Mark\n",
        "Age:           45\n",
        "Sex:           Male\n",
        "FavoriteColor: Green\n",
        "\n"
      ]
    end

    def one_person_chunk
      [
        "Name:          Mark",
        "Age:           45",
        "Sex:           Male",
        "FavoriteColor: Green"
      ]
    end

    def gerascophobic
      [
        "Name:          Jack\n",
        "Age: \n",
        "Sex:           Male\n",
        "FavoriteColor: Green\n",
        "\n"
      ]
    end

    def two_persons
      [
        "Name:          Mark\n",
        "Age:           45\n",
        "Sex:           Male\n",
        "FavoriteColor: Green\n",
        "\n",
        "Name:          Ruby\n",
        "Age:           25\n",
        "Sex:           Female\n",
        "FavoriteColor: Red\n",
        "\n"
      ]
    end

    def empty_persons_included
      [
        "Name:          Mark\n",
        "Age:           45\n",
        "Sex:           Male\n",
        "FavoriteColor: Green\n",
        "\n",
        " : \n",
        " : \n",
        " : \n",
        " : \n",
        "\n",
        "Name:          Ruby\n",
        "Age:           25\n",
        "Sex:           Female\n",
        "FavoriteColor: Red\n",
        "\n",
        " : \n",
        " : \n",
        " : \n",
        " : \n",
        "\n"
      ]
    end
end
