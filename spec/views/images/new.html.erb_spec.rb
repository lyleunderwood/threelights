require 'spec_helper'

describe "images/new.html.erb" do
  before(:each) do
    assign(:image, stub_model(Image,
      :name => "MyString",
      :description => "MyText"
    ).as_new_record)
  end

  it "renders new image form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => images_path, :method => "post" do
      assert_select "input#image_name", :name => "image[name]"
      assert_select "textarea#image_description", :name => "image[description]"
    end
  end
end
