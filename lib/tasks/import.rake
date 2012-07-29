require 'mysql2'

desc "Migrate stuff over from old coppermine tables"
task :import => :environment do
  client = Mysql2::Client.new(
    :host => 'localhost',
    :username => 'root',
    :password => 'root',
    :database => 'threelights',
    :encoding => 'utf8'
  )

  #import_categories(client)
  #import_albums(client)
  import_images(client)
end

task :count_missing_images => :environment do
  client = Mysql2::Client.new(
    :host => 'localhost',
    :username => 'root',
    :password => 'root',
    :database => 'threelights',
    :encoding => 'utf8'
  )

  results = client.query("SELECT COUNT(*) AS num FROM cpg1410_pictures");
  print results.first['num'].to_s + " original images\n"

  results = client.query("SELECT filename, pid, filesize FROM cpg1410_pictures")

  missing_images = []
  results.each do |row|
    missing_images << row['filename'] unless Image.where(:subject_file_size => row['filesize']).any?
  end

  missing_images.each do |image|
    print image + "\n"
  end

  print missing_images.count.to_s + " missing images\n"
end

task :update_views => :environment do
  client = Mysql2::Client.new(
    :host => 'localhost',
    :username => 'root',
    :password => 'root',
    :database => 'threelights',
    :encoding => 'utf8'
  )

  results = client.query("SELECT * FROM cpg1410_pictures");

  results.each do |row|
    img = Image.where(legacy_id: row['pid']).first
    img.update_attributes(views: row['hits']) if img and img.views != row['hits']
  end
end

def import_images(client)
  print "Starting Images\n"

  #Image.delete_all

  results = client.query("SELECT * FROM cpg1410_pictures")

  results.each do |row|
    print "Importing Image: #{row['filename']}\n"
    parent = Album.where(:legacy_id => row['aid']).first
    raise Exception.new("Parent album not found #{row['aid']} for image #{row['pid']}") unless parent

    image = Rails.root.join('data', 'pictures', row['filename'])

    next if Image.where(:legacy_id => row['pid']).any?

    unless File.exists? image.to_s
      p "Image missing: #{image.to_s}"
      next
    end

    image = File.open(image)

    geo = Paperclip::Geometry.from_file(image)

    name = row['title'].blank? ? row['filename'] : row['title']
    Image.create!({
      :name => decode(name),
      :description => decode(row['caption']),
      :album_id => parent.id,
      :views => row['hits'],
      :legacy_pos => row['position'],
      :created_at => Time.at(row['ctime']).to_datetime,
      :updated_at => Time.at(row['mtime']).to_datetime,
      :width => geo.width,
      :height => geo.height,
      :subject => image,
      :legacy_id => row['pid']
    })
  end
end

def import_albums(client)
  print "Starting Albums\n"

  Album.delete_all

  results = client.query("SELECT * FROM cpg1410_albums")

  results.each do |row|
    parent = Category.where(:legacy_id => row['category'] || 0).first
    raise Exception.new("Parent category #{row['category_id']} not found for album #{row['aid']}") unless parent

    Album.create!({
      :name => decode(row['title']),
      :description => decode(row['description']),
      :category_id => parent.id,
      :position => row['pos'],
      :legacy_id => row['aid']
    })
  end
end

# not super efficient lol
def import_categories(client)
  print "Starting Categories\n"

  Category.delete_all
  root = Category.create!(:name => 'ROOT', :description => 'Categories in this category are top-level.', :legacy_id => 0)

  results = client.query("SELECT * FROM cpg1410_categories WHERE name <> 'User Galleries'")

  results.each do |category_row|
    import_category(client, category_row)
  end
end

# recursive
def import_category(client, row)
  return if Category.where(:legacy_id => row['id']).first

  parent_id = row['parent']# == 0 ? nil : row['parent']
  unless parent = Category.where(:legacy_id => parent_id).first
    unless parent_row = client.query("SELECT * FROM cpg1410_categories WHERE cid = '#{row['parent']}'").first
      raise Exception.new("Parent category not found #{row['parent']} for category #{row['cid']}")
    end

    parent = import_category(client, parent_row)
  end

  Category.create!({
    :name => decode(row['name']),
    :description => decode(row['description']),
    :parent_id => parent.id,
    :legacy_id => row['cid']
  })
end

def decode(str)
  CGI.unescapeHTML str
end