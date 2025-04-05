require 'rspec/autorun'
require './scraper'
require 'json'

describe Scraper do

  subject { Scraper.new }
  let(:result) { subject.perform }
  let(:another_search) { Scraper.new "./files/claude-monet-paintings.html"}
  let(:mg_search) { Scraper.new "./files/miguel-angel-sculptures.html"}

  it 'should return a Hash' do
    expect(result).to be_a(Hash)
  end

  it 'should contain an artworks Array' do
    expect(result["artworks"]).to be_an(Array)
  end

  describe 'artworks' do
    let(:artwork) { result["artworks"][0] }
    let(:artwork_with_empty_extensions) { result["artworks"].select{|a| a["name"]=="Sunflowers"}.first}

    it "should contain a name" do
      expect(artwork["name"]).to be_a String
    end

    it "should not have an empty name" do
      expect(artwork["name"]).to_not be_empty
    end

    it "should contain link" do
      expect(artwork["link"]).to be_a String
    end

    it "should not have an empty link" do
      expect(artwork["link"]).to_not be_empty
    end

    it "should contain image" do 
      expect(artwork["image"]).to be_a String
    end

    it "should not contain an empty image" do
      expect(artwork["image"]).to_not be_empty
    end

    describe 'extensions' do
      it "must be an Array, if present" do
        expect(artwork["extensions"]).to be_an Array
      end

      it "can't contain empty Strings" do
        expect(artwork["extensions"]).not_to include("")
      end

      it "should not be present if value is empty" do
        expect(artwork_with_empty_extensions).not_to include("extensions")
      end
    end
  end

  it 'should be equal to example file' do
    file_data = File.open("./files/expected-array.json").read
    content = JSON.parse(file_data)
    expect(result).to eq(content)
  end

  it 'should work with other image search pages' do
    another_result = another_search.perform
    file_data = File.open("./files/expected-array-1.json").read
    content = JSON.parse(file_data)
    expect(another_result).to eq(content)
  end
  
  it 'should work with miguel angel too :)' do
    mg_result = mg_search.perform
    file_data = File.open("./files/expected-array-2.json").read
    content = JSON.parse(file_data)
    expect(mg_result).to eq(content)
  end

end