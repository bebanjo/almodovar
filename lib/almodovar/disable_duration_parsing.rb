# Disable automatic duration parsing in ActiveSupport::XmlMini for Rails 8+
# This fix removes the 'duration' parser so non-ISO values don't crash

if defined?(ActiveSupport::XmlMini::PARSING)
  ActiveSupport::XmlMini::PARSING = ActiveSupport::XmlMini::PARSING.except("duration").freeze
end
