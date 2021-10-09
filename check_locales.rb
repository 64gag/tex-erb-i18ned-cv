require_relative 'cv_i18n'
require 'yaml'

class LocaleFile
  def initialize(filename)
    @filename = filename
    @yaml = YAML.load(IO.read(@filename))
  end

  def filename
    @filename
  end

  def keys_number
    keys = _count_keys_in_yaml(@yaml)
    #puts "Keys number = #{keys}"
    keys
  end

  def array_uids_uniq(keys)
    array = _array_at_keys(keys)
    _array_uids(array).uniq if _check_array_exists(array) && _check_array_has_uids(array)
  end

  def check_array_at(keys)
    has_check_passed = true

    array = _array_at_keys(keys)
    has_check_passed = has_check_passed && _check_array_exists(array)
    has_check_passed = has_check_passed && _check_array_has_uids(array)

    #puts "check_array_at result = #{has_check_passed}"
    has_check_passed
  end

  def _array_at_keys(keys)
    array = @yaml[@yaml.keys[0]]

    keys.each do |key|
      #puts key
      array = array[key]
    end

    array
  end

  def _array_uids(array)
    uids = []

    array.each do |element|
      uids << element["uid"]
    end

    uids
  end

  def _check_array_exists(array)
    array.class == Array && !array.empty?
  end

  def _check_array_has_uids(array)
    _array_uids(array).uniq == _array_uids(array)
  end

  def _count_keys_in_yaml(yaml)
    keys_count = 0
    return keys_count unless [Hash, Array].include? yaml.class

    yaml.each do |key, value|
      keys_count = keys_count + 1
      keys_count = keys_count + _count_keys_in_yaml(value)
    end if yaml.class == Hash

    yaml.each do |value|
      keys_count = keys_count + _count_keys_in_yaml(value)
    end if yaml.class == Array
    #puts "KEYS in #{yaml} = #{keys_count}"

    keys_count
  end
end

class LocalesConsistencyChecker
  def initialize
    @locales = []
    Dir.glob("locales/??.yml") do |filename|
      @locales << LocaleFile.new(filename)
    end
  end

  def check
    check_keys_number
    check_arrays_have_same_keys(["professional", "entries"])
    check_arrays_have_same_keys(["education", "entries"])
    check_arrays_have_same_keys(["languages", "entries"])
    check_arrays_have_same_keys(["skills", "entries"])
    check_arrays_have_same_keys(["awards", "entries"])
  end

  def check_keys_number
    has_check_passed = true

    n = nil
    @locales.each do |locale|
      n = locale.keys_number if n == nil

      if n != locale.keys_number
        has_check_passed = false
        break
      end
    end

    puts "check_keys_number result = #{has_check_passed}"
    has_check_passed
  end

  def check_arrays_have_same_keys(keys)
    has_check_passed = true

    uids_reference = nil
    uids_current = nil

    @locales.each do |locale|
      uids_reference = locale.array_uids_uniq(keys) if uids_reference == nil

      uids_current = locale.array_uids_uniq(keys)

      unless locale.check_array_at(keys)
        has_check_passed = false
        break
      end

      puts "#{locale.filename} = #{uids_current.size}"

      if uids_reference != uids_current
        #puts uids_reference
        #puts uids_current
        has_check_passed = false
        break
      end
    end

    puts "check_arrays_have_same_keys(#{keys}) result = #{has_check_passed}"
    has_check_passed
  end
end

checker = LocalesConsistencyChecker.new
checker.check
