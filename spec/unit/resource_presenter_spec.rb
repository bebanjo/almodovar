require 'spec_helper'
require 'pry'

describe Almodovar::ResourcePresenter do
  
  before do
    class SeriesResource < Almodovar::ResourcePresenter
    end
  
    class SeriesEpisodeResource < Almodovar::ResourcePresenter
    end
  
    class ShowResource < Almodovar::ResourcePresenter
    end
  end
  
  after do
    Object.send :remove_const, :SeriesResource
    Object.send :remove_const, :SeriesEpisodeResource
    Object.send :remove_const, :ShowResource
  end
  
  describe '#to_xml' do
    
    it 'returns xml with a processing intruction' do
      xml = SeriesResource.new.to_xml
      
      xml.should have_processing_instruction('<?xml version="1.0" encoding="UTF-8"?>')
    end
    
    describe 'document root' do
      
      it 'returns the resource type as the document root' do
        xml = SeriesResource.new.to_xml
        xml.should match_xpath('/series')
      end
      
      it 'returns composed resource types' do
        xml = SeriesEpisodeResource.new.to_xml
        
        xml.should match_xpath('/series-episode')
      end
      
      it 'only includes the root when nothing is set' do
        xml = SeriesResource.new.to_xml
        
        xml.should_not match_xpath('/series/*')
      end
      
    end
    
    describe 'attributes' do
      
      it 'returns one attribute node when one attribute is set' do
        class SeriesResource
          def initialize
            attributes[:name] = 'Mad Men'
          end
        end
        
        xml = SeriesResource.new.to_xml
        
        xml.should match_xpath('/series/name[text() = "Mad Men"]')
      end
      
      it 'returns several attribute nodes when several attributes are set' do
        class SeriesResource
          def initialize
            attributes[:name] = 'Mad Men'
            attributes[:main_character] = 'Donald Draper'
          end
        end
        
        xml = SeriesResource.new.to_xml
        
        xml.should match_xpath('/series/name[text() = "Mad Men"]')
        xml.should match_xpath('/series/main-character[text() = "Donald Draper"]')
      end
      
      it 'specifies the type of non-string attributes' do
        class SeriesResource
          def initialize
            attributes[:id] = 20
          end
        end
        
        xml = SeriesResource.new.to_xml
        
        xml.should match_xpath('/series/id[@type = "integer"][text() = "20"]')
      end
      
      it 'keeps the assignment order of the attributes' do
        class SeriesResource
          def initialize
            attributes[:name] = 'Mad Men'
            attributes[:main_character] = 'Donald Draper'
          end
        end
        
        xml = SeriesResource.new.to_xml
        
        xml.should match_xpath('/series/*[position() = 1][self::name]')
        xml.should match_xpath('/series/*[position() = 2][self::main-character]')
      end
      
    end
    
    describe 'links' do
      
      it 'returns a link to self when url is set' do
        class SeriesResource
          def initialize
            self.url = 'http://example.com/resource'
          end
        end
        
        xml = SeriesResource.new.to_xml
        
        xml.should match_xpath('/series/link[@rel = "self"][@href = "http://example.com/resource"]')
      end
      
      it 'returns one link node when one link is set' do
        class SeriesResource
          def initialize
            links << Link.new(:episodes, 'http://example.com/episodes')
          end
        end
        
        xml = SeriesResource.new.to_xml
        
        xml.should match_xpath('/series/link[@rel = "episodes"][@href = "http://example.com/episodes"]')
      end
      
      it 'returns one link with attributes node when one link with attributes is set' do
        class SeriesResource
          def initialize
            links << Link.new(:episodes, 'http://example.com/episodes', nil, nil, :type => 'text/html')
          end
        end
        
        xml = SeriesResource.new.to_xml
        
        xml.should match_xpath('/series/link[@rel = "episodes"][@type = "text/html"]')
      end
      
      it 'returns several link nodes when several links are set' do
        class SeriesResource
          def initialize
            links << Link.new(:show,     'http://example.com/show')
            links << Link.new(:episodes, 'http://example.com/episodes')
          end
        end
        
        xml = SeriesResource.new.to_xml
        
        xml.should match_xpath('/series/link[@rel = "show"]')
        xml.should match_xpath('/series/link[@rel = "episodes"]')
      end
      
      it 'keeps the assignment order of the links' do
        class SeriesResource
          def initialize
            links << Link.new(:show,     'http://example.com/show')
            links << Link.new(:episodes, 'http://example.com/episodes')
          end
        end
        
        xml = SeriesResource.new.to_xml
        
        xml.should match_xpath('/series/link[position() = 1][@rel = "show"]')
      end
      
      describe 'expanding' do
        
        it "doesn't expand links without expand option" do
          class SeriesResource
            def initialize
              links << Link.new(:show, 'http://example.com/show', ShowResource)
            end
          end
          
          xml = SeriesResource.new.to_xml
          
          xml.should match_xpath('/series/link[not(node())]')
        end
        
        it "doesn't expand links with a expand option that doesn't specify the link rel" do
          class SeriesResource
            def initialize
              links << Link.new(:show, 'http://example.com/show', ShowResource)
            end
          end
          
          xml = SeriesResource.new.to_xml(:expand => :episodes)
          
          xml.should match_xpath('/series/link[not(node())]')
        end
        
        it "doesn't expand links when no expanding resource is specified" do
          class SeriesResource
            def initialize
              links << Link.new(:show, 'http://example.com/show')
            end
          end
          
          xml = SeriesResource.new.to_xml(:expand => :show)
          
          xml.should match_xpath('/series/link[not(node())]')
        end
        
        it 'expands links when a expanding resource is specified' do
          class SeriesResource
            def initialize
              links << Link.new(:show, 'http://example.com/show', ShowResource)
            end
          end
          
          xml = SeriesResource.new.to_xml(:expand => :show)
          
          xml.should match_xpath('/series/link/show')
        end
        
        it 'instantiates expanding resource passing expading args' do
          class ShowResource
            cattr_accessor :received
            
            def initialize(argument)
              self.received = argument
            end
          end
          
          class SeriesResource
            def initialize
              links << Link.new(:show, 'http://example.com/show', ShowResource, :argument_value)
            end
          end
          
          xml = SeriesResource.new.to_xml(:expand => :show)
          
          ShowResource.received.should == :argument_value
        end
        
        it 'expands multiple links given multiple rels' do
          class SeriesResource
            def initialize
              links << Link.new(:show, 'http://example.com/show', ShowResource)
              links << Link.new(:first_episode, 'http://example.com/episode', SeriesEpisodeResource)
              links << Link.new(:prev_show, 'http://example.com/prev_show', ShowResource)
            end
          end
          
          xml = SeriesResource.new.to_xml(:expand => [:show, :first_episode])
          
          xml.should match_xpath('/series/link/show')
          xml.should match_xpath('/series/link/series-episode')
          xml.should match_xpath('/series/link[@rel="prev_show"][not(node())]')
        end
        
        it 'expands links recursively' do
          class SeriesResource
            def initialize
              links << Link.new(:show, 'http://example.com/show', ShowResource)
            end
          end
          
          class SeriesEpisodeResource
            def initialize
              links << Link.new(:series, 'http://example.com/series', SeriesResource)
            end
          end
          
          xml = SeriesEpisodeResource.new.to_xml(:expand => [:show, :series])
          
          xml.should match_xpath('/series-episode/link/series/link/show')
        end
        
        it 'expands recursively avoiding infinite recursion' do
          class SeriesResource
            def initialize
              links << Link.new(:first_episode, 'http://example.com/episode/1', SeriesEpisodeResource)
            end
          end
          
          class SeriesEpisodeResource
            def initialize
              links << Link.new(:series, 'http://example.com/series', SeriesResource)
            end
          end
          
          xml = SeriesEpisodeResource.new.to_xml(:expand => [:first_episode, :series])
          
          xml.should match_xpath('/series-episode/link/series/link/series-episode/link[@rel="series"][not(node())]')
        end
        
        it 'stops recursion as soon as possible if root resource url is known' do
          class SeriesResource
            def initialize
              links << Link.new(:first_episode, 'http://example.com/episode/1', SeriesEpisodeResource)
            end
          end
          
          class SeriesEpisodeResource
            def initialize
              self.url = 'http://example.com/episode/1'
              links << Link.new(:series, 'http://example.com/series', SeriesResource)
            end
          end
          
          xml = SeriesEpisodeResource.new.to_xml(:expand => [:first_episode, :series])
          
          xml.should match_xpath('/series-episode/link/series/link[@rel="first_episode"][not(node())]')
        end
        
        it "expands the same resource more than once if there's no infinite recursion" do
          class ShowResource
            def initialize
              links << Link.new(:first_episode, 'http://example.com/episode/1', SeriesEpisodeResource)
              links << Link.new(:second_episode, 'http://example.com/episode/2', SeriesEpisodeResource)
            end
          end
          
          class SeriesEpisodeResource
            def initialize
              links << Link.new(:series, 'http://example.com/series', SeriesResource)
            end
          end
          
          xml = ShowResource.new.to_xml(:expand => [:first_episode, :second_episode, :series])
          
          xml.should match_xpath('/show/link[@rel="first_episode"]/series-episode/link/series')
          xml.should match_xpath('/show/link[@rel="second_episode"]/series-episode/link/series')
        end
        
        it 'never expands link to self' do
          class SeriesResource
            def initialize
              self.url = 'http://example.com/series'
              links << Link.new(:show, 'http://example.com/show', ShowResource)
            end
          end
          
          xml = SeriesResource.new.to_xml(:expand => [:self, :show])
          
          xml.should_not match_xpath('//link[@rel="self"][node()]')
        end
        
        it 'expands resource collections' do
          class SeriesEpisodeResource
            cattr_accessor :received
            self.received = []
            
            def initialize(argument)
              self.received << argument
            end
          end
          
          class SeriesResource
            def initialize
              links << Link.new(:episodes, 'http://example.com/episodes', SeriesEpisodeResource, [1, 2])
            end
          end
          
          xml = SeriesResource.new.to_xml(:expand => :episodes)
          
          xml.should match_xpath('//link[@rel="episodes"]/series-episodes/series-episode[position() = 2][last()]')
          SeriesEpisodeResource.received.should == [1, 2]
        end
        
        it "doesn't recurse infinitely with resource collections" do
          class SeriesResource
            def initialize
              links << Link.new(:episodes, 'http://example.com/episodes', SeriesEpisodeResource, [1, 2])
            end
          end
          
          class SeriesEpisodeResource
            def initialize(id)
              links << Link.new(:series, 'http://example.com/series', SeriesResource)
            end
          end
          
          xml = SeriesResource.new.to_xml(:expand => [:episodes, :series])
          
          xml.should match_xpath('/series/link/series-episodes/series-episode/link/series/link[@rel="episodes"][not(node())]')
        end
        
      end
      
    end
    
  end
  
  describe '#to_json' do
    
    describe 'resource_type' do
      
      it 'returns the resource type as the document root' do
        json = SeriesResource.new.to_json
        
        parse_json(json)['resource_type'].should == 'series'
      end
      
      it 'returns composed resource types' do
        json = SeriesEpisodeResource.new.to_json
        
        parse_json(json)['resource_type'].should == 'series_episode'
      end
      
      it 'only includes the root when nothing is set' do
        json = SeriesResource.new.to_json

        parse_json(json).size.should == 1
      end
      
    end
    
    describe 'attributes' do
      
      it 'returns one attribute node when one attribute is set' do
        class SeriesResource
          def initialize
            attributes[:name] = 'Mad Men'
          end
        end
        
        json = SeriesResource.new.to_json
        
        parse_json(json)['name'].should == 'Mad Men'
      end
      
      it 'returns several attribute nodes when several attributes are set' do
        class SeriesResource
          def initialize
            attributes[:name] = 'Mad Men'
            attributes[:main_character] = 'Donald Draper'
          end
        end
        
        json = SeriesResource.new.to_json
        
        parse_json(json)['name'].should == 'Mad Men'
        parse_json(json)['main_character'].should == 'Donald Draper'
      end
      
      it 'specifies the type of non-string attributes' do
        class SeriesResource
          def initialize
            attributes[:id] = 20
          end
        end
        
        json = SeriesResource.new.to_json
        
        parse_json(json)['id'].should == 20
      end
      
      it 'keeps the assignment order of the attributes' do
        class SeriesResource
          def initialize
            attributes[:name] = 'Mad Men'
            attributes[:main_character] = 'Donald Draper'
          end
        end
        
        json = SeriesResource.new.to_json
        
        json.index('name').should be < json.index('main_character')
      end
      
    end
    
    describe 'links' do
      
      it 'returns a link to self when url is set' do
        class SeriesResource
          def initialize
            self.url = 'http://example.com/resource'
          end
        end
        
        json = SeriesResource.new.to_json
        
        parse_json(json)['self_link'].should == 'http://example.com/resource'
      end
      
      it 'returns one link node when one link is set' do
        class SeriesResource
          def initialize
            links << Link.new(:episodes, 'http://example.com/episodes')
          end
        end
        
        json = SeriesResource.new.to_json
        
        parse_json(json)['episodes_link'].should == 'http://example.com/episodes'
      end
      
      it 'returns several link nodes when several links are set' do
        class SeriesResource
          def initialize
            links << Link.new(:show,     'http://example.com/show')
            links << Link.new(:episodes, 'http://example.com/episodes')
          end
        end
        
        json = SeriesResource.new.to_json
        
        parse_json(json)['show_link'].should     == 'http://example.com/show'
        parse_json(json)['episodes_link'].should == 'http://example.com/episodes'
      end
      
      it 'keeps the assignment order of the links' do
        class SeriesResource
          def initialize
            links << Link.new(:show,     'http://example.com/show')
            links << Link.new(:episodes, 'http://example.com/episodes')
          end
        end
        
        json = SeriesResource.new.to_json
        
        json.index('show').should be < json.index('episodes')
      end
          
      describe 'expanding' do
        
        it "doesn't expand links without expand option" do
          class SeriesResource
            def initialize
              links << Link.new(:show, 'http://example.com/show', ShowResource)
            end
          end
          
          json = SeriesResource.new.to_json
          
          parse_json(json).should_not have_key('show')
        end
        
        it "doesn't expand links with a expand option that doesn't specify the link rel" do
          class SeriesResource
            def initialize
              links << Link.new(:show, 'http://example.com/show', ShowResource)
            end
          end

          json = SeriesResource.new.to_json(:expand => :episodes)
          
          parse_json(json).should_not have_key('show')
        end
        
        it "doesn't expand links when no expanding resource is specified" do
          class SeriesResource
            def initialize
              links << Link.new(:show, 'http://example.com/show')
            end
          end
          
          json = SeriesResource.new.to_json(:expand => :show)
          
          parse_json(json).should_not have_key('show')
        end
        
        it 'expands links when a expanding resource is specified' do
          class SeriesResource
            def initialize
              links << Link.new(:show, 'http://example.com/show', ShowResource)
            end
          end
          
          json = SeriesResource.new.to_json(:expand => :show)
          
          parse_json(json)['show'].should be_present
        end
        
        it 'instantiates expanding resource passing expading args' do
          class ShowResource
            cattr_accessor :received
            
            def initialize(argument)
              self.received = argument
            end
          end
          
          class SeriesResource
            def initialize
              links << Link.new(:show, 'http://example.com/show', ShowResource, :argument_value)
            end
          end
          
          json = SeriesResource.new.to_json(:expand => :show)
          
          ShowResource.received.should == :argument_value
        end
        
        it 'expands multiple links given multiple rels' do
          class SeriesResource
            def initialize
              links << Link.new(:show, 'http://example.com/show', ShowResource)
              links << Link.new(:first_episode, 'http://example.com/episode', SeriesEpisodeResource)
              links << Link.new(:prev_show, 'http://example.com/prev_show', ShowResource)
            end
          end
          
          json = SeriesResource.new.to_json(:expand => [:show, :first_episode])
          
          parse_json(json).tap do |json|  
            json['show'].should be_present
            json['first_episode'].should be_present
            json['prev_show'].should_not be_present
          end
        end
        
        it 'expands links recursively' do
          class SeriesResource
            def initialize
              links << Link.new(:show, 'http://example.com/show', ShowResource)
            end
          end
          
          class SeriesEpisodeResource
            def initialize
              links << Link.new(:series, 'http://example.com/series', SeriesResource)
            end
          end
          
          json = SeriesEpisodeResource.new.to_json(:expand => [:show, :series])
          
          parse_json(json)['series']['show'].should be_present
        end
        
        it 'expands recursively avoiding infinite recursion' do
          class SeriesResource
            def initialize
              links << Link.new(:first_episode, 'http://example.com/episode/1', SeriesEpisodeResource)
            end
          end
          
          class SeriesEpisodeResource
            def initialize
              links << Link.new(:series, 'http://example.com/series', SeriesResource)
            end
          end
          
          json = SeriesEpisodeResource.new.to_json(:expand => [:first_episode, :series])
          
          parse_json(json)['series']['first_episode'].tap do |episode|
            episode.should have_key('series_link')
            episode.should_not have_key('series')
          end
        end
        
        it 'stops recursion as soon as possible if root resource url is known' do
          class SeriesResource
            def initialize
              links << Link.new(:first_episode, 'http://example.com/episode/1', SeriesEpisodeResource)
            end
          end
          
          class SeriesEpisodeResource
            def initialize
              self.url = 'http://example.com/episode/1'
              links << Link.new(:series, 'http://example.com/series', SeriesResource)
            end
          end
          
          json = SeriesEpisodeResource.new.to_json(:expand => [:first_episode, :series])
          
          parse_json(json)['series'].tap do |series|
            series.should have_key('first_episode_link')
            series.should_not have_key('first_episode')
          end
        end
        
        it "expands the same resource more than once if there's no infinite recursion" do
          class ShowResource
            def initialize
              links << Link.new(:first_episode, 'http://example.com/episode/1', SeriesEpisodeResource)
              links << Link.new(:second_episode, 'http://example.com/episode/2', SeriesEpisodeResource)
            end
          end
          
          class SeriesEpisodeResource
            def initialize
              links << Link.new(:series, 'http://example.com/series', SeriesResource)
            end
          end
          
          json = ShowResource.new.to_json(:expand => [:first_episode, :second_episode, :series])
          
          parse_json(json)['second_episode']['series'].should be_present
        end
        
        it 'never expands link to self' do
          class SeriesResource
            def initialize
              self.url = 'http://example.com/series'
              links << Link.new(:show, 'http://example.com/show', ShowResource)
            end
          end
          
          json = SeriesResource.new.to_json(:expand => [:self, :show])
          
          parse_json(json).tap do |json|
            json['self_link'].should be_present
            json['self'].should_not be_present
          end
        end
        
        it 'expands resource collections' do
          class SeriesEpisodeResource            
            def initialize(argument)
              attributes[:name] = "Ep.#{argument}"
            end
          end
          
          class SeriesResource
            def initialize
              links << Link.new(:episodes, 'http://example.com/episodes', SeriesEpisodeResource, [1, 2])
            end
          end
          
          json = SeriesResource.new.to_json(:expand => :episodes)
          
          parse_json(json)['episodes'].tap do |episodes|
            episodes.should be_present
            episodes['entries'].should be_present
            episodes['entries'].length.should == 2
            episodes['entries'][1]['name'].should == 'Ep.2'
          end
        end
        
        it "doesn't recurse infinitely with resource collections" do
          class SeriesResource
            def initialize
              links << Link.new(:episodes, 'http://example.com/episodes', SeriesEpisodeResource, [1, 2])
            end
          end
          
          class SeriesEpisodeResource
            def initialize(id)
              links << Link.new(:series, 'http://example.com/series', SeriesResource)
            end
          end
          
          json = SeriesResource.new.to_json(:expand => [:episodes, :series])
          
          parse_json(json)['episodes']['entries'][0]['series'].tap do |series|
            series.should have_key('episodes_link')
            series.should_not have_key('episodes')
          end
        end
        
      end
      
    end
    
  end
  
end
