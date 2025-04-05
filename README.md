# Extract Van Gogh Paintings Code Challenge

Goal is to extract a list of Van Gogh paintings from the attached Google search results page.

![Van Gogh paintings](https://github.com/serpapi/code-challenge/blob/master/files/van-gogh-paintings.png?raw=true "Van Gogh paintings")

## Instructions

This is already fully supported on SerpApi. ([relevant test], [html file], [sample json], and [expected array].)
Try to come up with your own solution and your own test.
Extract the painting `name`, `extensions` array (date), and Google `link` in an array.

Fork this repository and make a PR when ready.

Programming language wise, Ruby (with RSpec tests) is strongly suggested but feel free to use whatever you feel like.

Parse directly the HTML result page ([html file]) in this repository. No extra HTTP requests should be needed for anything.

[relevant test]: https://github.com/serpapi/test-knowledge-graph-desktop/blob/master/spec/knowledge_graph_claude_monet_paintings_spec.rb
[sample json]: https://raw.githubusercontent.com/serpapi/code-challenge/master/files/van-gogh-paintings.json
[html file]: https://raw.githubusercontent.com/serpapi/code-challenge/master/files/van-gogh-paintings.html
[expected array]: https://raw.githubusercontent.com/serpapi/code-challenge/master/files/expected-array.json

Add also to your array the painting thumbnails present in the result page file (not the ones where extra requests are needed). 

Test against 2 other similar result pages to make sure it works against different layouts. (Pages that contain the same kind of carrousel. Don't necessarily have to be paintings.)

The suggested time for this challenge is 4 hours. But, you can take your time and work more on it if you want.

## Solution

I tried to keep the solution in its simplest form. It's basically a file and a test file. I added the 
Gemfile at the end for convenience.

The instructions only said that it must work for the same kind of carrousel, which is very specific
since other image searches show a different type of carrousel.

My focus was to reproduce the same result as the expected-array.json file and without making any 
http requests. And of course the test suite which I want to elaborate a little:

- I think every test should have only 1 expect.
- Every test must have a clear goal, with only 1 scenario.

I think it is better appreciated in the following section:

```ruby
let(:artwork_with_empty_extensions) { result["artworks"].select{|a| a["name"]=="Sunflowers"}.first}
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
```

There was an scenario where the extensions are not set, in the expected results the extensions were
not present, so I provided a specific scenario to the test so it can be properly tested.

### To test

Just run
```
bundle install
ruby test.rb
```