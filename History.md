# Almodovar Release History

## Version 0.6.1 (2012-05-03)

### Features

* Throws an exception when the HTTP return an error with status code. See Almodovar::HttpError

## Version 0.6.0 (2011-10-07)

### Features

* Create a resource linking to existing resources
* ResourcePresenter

### Other

* Enable Travis build
* Works with Ruby 1.9.2 :)
* Replace Resourceful with Patron
* Create this history document ;)

## Version 0.5.6 (2010-12-16)

### Bugfixes

* Fix HTTP_HOST header bug in vendored Resourceful
* Using a port different than default

### Other

* Bundler + Specific working versions of ActiveSupport, Rspec & Webmock

## Version 0.5.5 (2010-11-05)

### Bugfixes

* When Single Resources hanged from a Single Resource, the object_type was not being derived correctly

## Version 0.5.4 (2010-08-26)

### Bugfixes

* type="document" doesn't work when used in the root node

## Version 0.5.3 (2010-08-19)

### Features

* Support for several nodes in included documents

## Version 0.5.2 (2010-08-18)

### Other

* Alternative (simpler) implementation of included documents

## Version 0.5.1 (2010-08-18)

### Bugfixes

* Support for attributes called "type"

## Version 0.5.0 (2010-08-18)

### Features

* Reading nodes of type "document"
* Reading nodes of type "array" not included in expanded links

## Version 0.4.0 (2010-05-24)

### Features

* Almodovar::Resource.from_xml (instantiate resources without HTTP call)

## Version: 0.3.2 (2010-05-20)

### Bugfixes

* Sometimes ResourceCollection is treated as SingleResource

## Version 0.3.1 (2010-05-19)

### Bugfixes

* Link expansion when creating resources

## Version 0.3.0 (2010-05-18)

### Features

* Support for creating nested resources

## Version 0.2.0 (2010-05-18)

### Features

* Almodovar::Resource#inspect returns an XML dump
* Almodovar is lazy now (no HTTP calls until needed)
* Create, update & delete support

### Other

* Updated docs with resource create, update & delete

## Version 0.1.2 (2010-05-12)

## Version 0.1.0 (2010-04-12)

* Initial version :)
