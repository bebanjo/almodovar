require 'spec_helper'

describe Hash do
  
  describe "to_xml" do
    
    it "should convert the nested resources into 'link' tags if the :convert_links option is present" do
      xml = Nokogiri::XML.parse({"name" => "Almodovar", "tasks" => [{"name" => "Wadus"}]}.to_xml(:root => "project", :convert_links => true, :skip_links_one_level => true))
      
      # <project>
      #   <name>Almodovar</name>
      #   <link rel="tasks">
      #     <tasks type="array">
      #       <task>
      #         <name>Wadus</name>
      #       </task>
      #     </tasks>
      #   </link>
      # </project>
      expect(xml.at_xpath("/project/name").text).to eq("Almodovar")
      expect(xml.at_xpath("/project/tasks")).to be_nil
      expect(xml.at_xpath("/project/link[@rel='tasks']/tasks[@type='array']/task/name").text).to eq("Wadus")
    end
    
    it "should not convert the nested resources into 'link' tags if the :convert_links option is not present" do
      xml = Nokogiri::XML.parse({"name" => "Almodovar", "tasks" => [{"name" => "Wadus"}]}.to_xml(:root => "project", :convert_links => false))

      # <project>
      #   <name>Almodovar</name>
      #   <tasks type="array">
      #     <task>
      #       <name>Wadus</name>
      #     </task>
      #   </tasks>
      # </project>      
      expect(xml.at_xpath("/project/name").text).to eq("Almodovar")
      expect(xml.at_xpath("//link")).to be_nil
      expect(xml.at_xpath("/project/tasks[@type='array']/task/name").text).to eq("Wadus")
    end
    
    
  end
  
end

describe Array do
  
  describe "to_xml" do
    
    it "should convert an array into xml" do
      expect([].to_xml).to eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<nil-classes type=\"array\"/>\n")
    end
    
    it "should be able to receive a block" do
      xml = [{}].to_xml { |xml| xml.wadus "Almodovar" }
      xml = Nokogiri::XML.parse(xml)

      expect(xml.at_xpath("//wadus").text).to eq("Almodovar")
    end

  end
  
end