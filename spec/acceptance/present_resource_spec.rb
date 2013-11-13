require 'spec_helper'

describe 'Presenting resources' do
  
  before do
    class Series < Struct.new(:id, :name, :show, :episodes)
    end
    
    class ShowResource < Almodovar::ResourcePresenter
      def initialize(model)
        attributes[:name] = model[:name]
      end
    end

    class SeriesResource < Almodovar::ResourcePresenter
      desc 'A Series is a group of episodes'
      attribute :name, :desc => 'The title of the series'
      link :show, :desc => 'The show the series belongs to'

      def initialize(model)
        self.url = "http://wadus.com/series/#{model.id}"
      
        attributes[:id]   = model.id
        attributes[:name] = model.name
      
        links << Link.new(:show, "http://wadus.com/show/20", ShowResource, model.show)
        links << Link.new(:episodes, "http://wadus.com/series/#{model.id}/episodes?param=1&param=2", EpisodeResource, model.episodes)
      end
    end
  
    class EpisodeResource < Almodovar::ResourcePresenter
      def initialize(model)
        attributes[:title] = model[:name]
      end
    end
  end
  
  after do
    Object.send :remove_const, :Series
    Object.send :remove_const, :ShowResource
    Object.send :remove_const, :SeriesResource
    Object.send :remove_const, :EpisodeResource
  end
  
  example 'Presenting a resource in xml format' do
    resource = SeriesResource.new(Series.new(5, 'Mad Men S1'))
    
    resource.to_xml.should equal_xml <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<series>
  <id type="integer">5</id>
  <name>Mad Men S1</name>
  <link rel="self" href="http://wadus.com/series/5"/>
  <link rel="show" href="http://wadus.com/show/20"/>
  <link rel="episodes" href="http://wadus.com/series/5/episodes?param=1&param=2"/>
</series>
XML
  end
  
  example 'Presenting a resource in xml format expanding its links' do
    series = Series.new(5, 'Mad Men S1', {:name => 'Mad Men'}, [{:name => 'Ep1'}, {:name => 'Ep2'}])
    
    resource = SeriesResource.new(series)
    
    resource.to_xml(:expand => [:show, :episodes]).should equal_xml <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<series>
  <id type="integer">5</id>
  <name>Mad Men S1</name>
  <link rel="self" href="http://wadus.com/series/5"/>
  <link rel="show" href="http://wadus.com/show/20">
    <show>
      <name>Mad Men</name>
    </show>
  </link>
  <link rel="episodes" href="http://wadus.com/series/5/episodes?param=1&param=2">
    <episodes type="array">
      <episode>
        <title>Ep1</title>
      </episode>
      <episode>
        <title>Ep2</title>
      </episode>
    </episodes>
  </link>
</series>
XML
  end

  example 'Presenting a resource collection in xml format with options' do
    collection = []
    1.upto(3) { |i| collection << Series.new(i, 'Mad Men S1')}

    resources = Almodovar::ResourcePresenter::Collection.new(SeriesResource, collection, { :total_entries => 3, :next_link => 'http://wadus.com/series?after=3&per_page=10' })

    resources.to_xml.should equal_xml <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<series type="array">
  <total-entries>3</total-entries>
  <link rel="next" href="http://wadus.com/series?after=3&per_page=10"/>
  <series>
    <id type="integer">1</id>
    <name>Mad Men S1</name>
    <link rel="self" href="http://wadus.com/series/1"/>
    <link rel="show" href="http://wadus.com/show/20"/>
    <link rel="episodes" href="http://wadus.com/series/1/episodes?param=1&param=2"/>
  </series>
  <series>
    <id type="integer">2</id>
    <name>Mad Men S1</name>
    <link rel="self" href="http://wadus.com/series/2"/>
    <link rel="show" href="http://wadus.com/show/20"/>
    <link rel="episodes" href="http://wadus.com/series/2/episodes?param=1&param=2"/>
  </series>
  <series>
    <id type="integer">3</id>
    <name>Mad Men S1</name>
    <link rel="self" href="http://wadus.com/series/3"/>
    <link rel="show" href="http://wadus.com/show/20"/>
    <link rel="episodes" href="http://wadus.com/series/3/episodes?param=1&param=2"/>
  </series>
</series> 
XML
  end
  
  example 'Presenting a resource in json format' do
    resource = SeriesResource.new(Series.new(5, 'Mad Men S1'))
    
    resource.to_json.should == <<-JSON
{
  "resource_type": "series",
  "id": 5,
  "name": "Mad Men S1",
  "self_link": "http://wadus.com/series/5",
  "show_link": "http://wadus.com/show/20",
  "episodes_link": "http://wadus.com/series/5/episodes?param=1&param=2"
}
JSON
  end
  
  example 'Presenting a resource in json format expanding its links' do
    series = Series.new(5, 'Mad Men S1', {:name => 'Mad Men'}, [{:name => 'Ep1'}, {:name => 'Ep2'}])
    
    resource = SeriesResource.new(series)
    
    resource.to_json(:expand => [:show, :episodes]).should == <<-JSON
{
  "resource_type": "series",
  "id": 5,
  "name": "Mad Men S1",
  "self_link": "http://wadus.com/series/5",
  "show_link": "http://wadus.com/show/20",
  "show": {
    "resource_type": "show",
    "name": "Mad Men"
  },
  "episodes_link": "http://wadus.com/series/5/episodes?param=1&param=2",
  "episodes": {
    "entries": [
      {
        "resource_type": "episode",
        "title": "Ep1"
      },
      {
        "resource_type": "episode",
        "title": "Ep2"
      }
    ]
  }
}
JSON
  end

  example 'Presenting a resource in json format with options' do
    collection = []
    1.upto(3) { |i| collection << Series.new(i, 'Two and a Half Men ')}

    resources = Almodovar::ResourcePresenter::Collection.new(SeriesResource, collection, { :total_entries => 3, :prev_link => 'http://wadus.com/series?before=1' })
    resources.to_json.should == <<-JSON
{
  "total_entries": 3,
  "prev_link": "http://wadus.com/series?before=1",
  "entries": [
    {
      "resource_type": "series",
      "id": 1,
      "name": "Two and a Half Men ",
      "self_link": "http://wadus.com/series/1",
      "show_link": "http://wadus.com/show/20",
      "episodes_link": "http://wadus.com/series/1/episodes?param=1&param=2"
    },
    {
      "resource_type": "series",
      "id": 2,
      "name": "Two and a Half Men ",
      "self_link": "http://wadus.com/series/2",
      "show_link": "http://wadus.com/show/20",
      "episodes_link": "http://wadus.com/series/2/episodes?param=1&param=2"
    },
    {
      "resource_type": "series",
      "id": 3,
      "name": "Two and a Half Men ",
      "self_link": "http://wadus.com/series/3",
      "show_link": "http://wadus.com/show/20",
      "episodes_link": "http://wadus.com/series/3/episodes?param=1&param=2"
    }
  ]
}
JSON
  end

  example 'Presenting a resource in html format expanding its links' do
    series = Series.new(5, 'Mad Men S1', {:name => 'Mad Men'}, [{:name => 'Ep1'}, {:name => 'Ep2'}])
    
    resource = SeriesResource.new(series)
    
    html = resource.to_html(:expand => [:show, :episodes])

    # XML tab
    html.should have_text('<name>Mad Men S1</name>')
    html.should have_text('<name>Mad Men</name>')
    html.should have_text('<title>Ep1</title>')

    # Reference tab
    html.should have_text('Series')
    html.should have_text('A Series is a group of episodes')
    html.should have_text('name The title of the series')
    html.should have_text('show The show the series belongs to')
  end                        

  example 'Presenting a resource collection in html format expanding its links' do
    collection = 3.times.map { |i| Series.new(i, "Mad Men S#{i}", {:name => 'Mad Men'})}

    resources = Almodovar::ResourcePresenter::Collection.new(
      SeriesResource, collection, :total_entries => 3
    )

    html = resources.to_html(:expand => :show)

    # XML tab
    html.should have_text('<total-entries>3</total-entries>')
    html.should have_text('<name>Mad Men S1</name>')
    html.should have_text('<name>Mad Men</name>')

    # Reference tab
    html.should have_text('A Series is a group of episodes')
  end
end
