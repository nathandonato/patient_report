class Search
  def initialize
    @found = false
  end

  def find(obj, *keys)
    if obj.nil? || keys[0].nil?
      raise 'Must specify a needle and a haystack: find(haystack, "keys", "to", needle)'
    end

    @val = keys.last
    iterate(obj, *keys - [@val])
    @found
  end

  def iterate(obj, *keys)
    if obj === @val && keys.empty?
      @found = true
    elsif obj.is_a? Array
      obj.each { |i| iterate(i, *keys) }
    elsif obj.is_a? OpenStruct or obj.is_a? Struct
      check_struct(obj, *keys)
    end
  end

  def check_struct(obj, *keys)
    obj.each_pair { |k, v|
      if k.to_s == keys[0]
        new_keys = keys - [keys[0]]
        iterate(v, *new_keys)
      end
    }
  end
end
