require 'spec_helper'

describe "albums/new.html.erb" do
  before(:each) do
    assign(:album, stub_model(Album,
      :name => "MyString",
      :description => "MyText"
    ).as_new_record)
  end

  it "renders new album form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => albums_path, :method => "post" do
      assert_select "input#album_name", :name => "album[name]"
      assert_select "textarea#album_description", :name => "album[description]"
    end
  end
end
