# Disable automatic duration parsing in ActiveSupport::XmlMini for Rails 8+
# This fix removes the 'duration' parser so non-ISO values don't crash

# module ActiveSupport
#   module XmlMini
#     PARSING = PARSING.except("duration").freeze
#   end
# end
