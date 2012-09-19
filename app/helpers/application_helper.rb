module ApplicationHelper
  def breadcrumb target
    trail = []

    if target.is_a? Category
      path = target.ancestors
      path << target

      trail = path.collect do |category|
        if category.name.eql? 'ROOT'
          link_to('Home', root_path)
        else
          link_to(category.name, category)
        end
      end

    elsif target.is_a? Album
      path = target.category.ancestors
      path << target.category

      trail = path.collect do |category|
        if category.name.eql? 'ROOT'
          link_to('Home', root_path)
        else
          link_to(category.name, category)
        end
      end

      trail << link_to(raw(target.name), [target.category, target])
    elsif target.is_a? Image
      path = target.album.category.ancestors
      path << target.album.category

      trail = path.collect do |category|
        if category.name.eql? 'ROOT'
          link_to('Home', root_path)
        else
          link_to(category.name, category)
        end
      end

      trail << link_to(raw(target.album.name), [target.album.category, target.album])
      trail << link_to(target.name, [target.album.category, target.album, target])
    end
    trail
  end

  def if_admin
    yield if user_signed_in?
  end

  def is_admin?
    user_signed_in?
  end

  def title(part)
    title = "Three-Lights.net Gallery"
    title = "#{part.to_s} :: #{title}" if part
    content_for :title, raw(title)
  end
end
