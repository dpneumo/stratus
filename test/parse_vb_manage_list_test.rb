require 'test_helper'
require_relative '../parse_vb_manage_list'

class TestParseVbManageList < MiniTest::Test
  def setup
    @pvl = ParseVbManageList.new
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

  def test_parse_handles_variants_of_bad_string_pairs
    list = [ "a:b\n", "\n", ":\n", "d:\n", ":g\n", "\n"]
    expected = [{'a'=>'b'}, {'d'=>''}]
    assert_equal expected, @pvl.parse(list)
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

