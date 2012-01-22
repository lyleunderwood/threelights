require 'mysql2'

desc "Migrate stuff over from old coppermine tables"
task :import =>:environment do
  client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => 'root', :database => 'threelights')

  import_categories(client)
  import_albums(client)
  import_images(client)
end


def import_albums(client)
  Album.delete_all

  results = client.query("SELECT * FROM cpg1410_albums")

  results.each do |row|
    parent = Category.where(legacy_id: row['category'] || 0).first
    raise Exception.new("Parent category #{row['category_id']} not found for album #{row['aid']}") unless parent

    Album.create!(
      name: row['title'],
      description: row['description'],
      category_id: parent.id,
      position: row['pos'],
      legacy_id: row['aid']
    )
  end
end

# not super efficient lol
def import_categories(client)
  Category.delete_all
  root = Category.create!(name: 'ROOT', description: 'Categories in this category are top-level.', legacy_id: 0)

  results = client.query("SELECT * FROM cpg1410_categories")

  results.each do |category_row|
    import_category(client, category_row)
  end
end

# recursive
def import_category(client, row)
  return if Category.where(legacy_id: row['id']).first

  parent_id = row['parent']# == 0 ? nil : row['parent']
  unless parent = Category.where(legacy_id: parent_id).first
    unless parent_row = client.query("SELECT * FROM cpg1410_categories WHERE cid = '#{row['parent']}'").first
      raise Exception.new("Parent category not found #{row['parent']} for category #{row['cid']}")
    end

    parent = import_category(client, parent_row)
  end

  Category.create!(
    name: row['name'],
    description: row['description'],
    parent_id: parent.id,
    legacy_id: row['cid']
  )
end

def import_images(client)
  Image.delete_all

  results = client.query("SELECT * FROM cpg1410_pictures")

  results.each do |row|
    parent = Album.where(legacy_id: row['aid']).first
    raise Exception.new("Parent album not found #{row['aid']} for image #{row['pid']}") unless parent

    #image =
    #geo = Paperclip::Geometry.from_file(image)
    #geo.width
    #geo.height

    name = row['title'].blank? ? row['filename'] : row['title']
    Image.create!(
      name: name,
      description: row['caption'],
      album_id: parent.id,
      views: row['hits'],
      legacy_pos: row['position'],
      created_at: Time.at(row['ctime']).to_datetime,
      updated_at: Time.at(row['mtime']).to_datetime
    )
  end
end