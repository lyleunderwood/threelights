module CategoriesHelper
  def cat_parent_path category
    (category.parent.present? and !category.parent.name.eql? 'ROOT')? category.parent : root_path
  end
end
