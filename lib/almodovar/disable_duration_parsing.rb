# Removes the 'duration' parser from ActiveSupport::XmlMini to prevent errors when processing non-ISO duration values in Rails 8+
# This patch modifies the PARSING constant so that ActiveSupport does not automatically convert duration values, preventing unexpected failures.
module ActiveSupport
  module XmlMini
    if const_defined?(:PARSING)
      new_parsing = PARSING.except("duration").freeze
      remove_const(:PARSING)
      const_set(:PARSING, new_parsing)
    end
  end
end
