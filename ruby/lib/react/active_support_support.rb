class String
  def demodulize
    if i = self.rindex("::")
      self[(i + 2)..-1]
    else
      self
    end
  end

  def deconstantize
    self[0, self.rindex("::") || 0] # implementation based on the one in facets' Module#spacename
  end
end