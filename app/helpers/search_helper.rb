module SearchHelper
  def hl(result, field)
    if result.respond_to?(:highlight) and hit = result.highlight[field]
      return raw hit.first
    end

    result.send field
  end
end
