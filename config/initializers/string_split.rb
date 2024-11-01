class Object
  def split_strip
    to_s.split(/[,，]/).map(&:squish)
  end

  def squish
    to_s.squish
  end
end
