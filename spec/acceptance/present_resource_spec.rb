require 'spec_helper'

feature 'Presenting resources' do
  
  class Series < Struct.new(:id, :name, :show, :episodes)
  end
    
  class ShowResource < Almodovar::ResourcePresenter
    def initialize(model)
      attributes[:name] = model[:name]
    end
  end

  class SeriesResource < Almodovar::ResourcePresenter
    def initialize(model)
      self.url = "http://wadus.com/series/#{model.id}"
      
      attributes[:id]   = model.id
      attributes[:name] = model.name
      
      links << Link.new(:show, "http://wadus.com/show/20", ShowResource, model.show)
      links << Link.new(:episodes, "http://wadus.com/series/#{model.id}/episodes", EpisodeResource, model.episodes)
    end
  end
  
  class EpisodeResource < Almodovar::ResourcePresenter
    def initialize(model)
      attributes[:title] = model[:name]
    end
  end
  
  scenario 'Presenting a resource in xml format' do
    resource = SeriesResource.new(Series.new(5, 'Mad Men S1'))
    
    resource.to_xml.should equal_xml <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<series>
  <id type="integer">5</id>
  <name>Mad Men S1</name>
  <link rel="self" href="http://wadus.com/series/5"/>
  <link rel="show" href="http://wadus.com/show/20"/>
  <link rel="episodes" href="http://wadus.com/series/5/episodes"/>
</series>
XML
  end
  
  scenario 'Presenting a resource in xml format expanding its links' do
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
  <link rel="episodes" href="http://wadus.com/series/5/episodes">
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
  
end