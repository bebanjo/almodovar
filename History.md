# Almodovar Release History

## Version 2.0.1 (2023-06-08)

## Feature

* Add support to specify query params when deleting resources [#80](https://github.com/bebanjo/almodovar/pull/80)

## Version 2.0.0 (2023-04-25)

## Feature

* Update Nokogiri to v1.12 for Ruby 3 support [#79](https://github.com/bebanjo/almodovar/pull/79)

## Version 1.8.0 (2023-02-06)

## Feature

* Add specific TooManyRequestsError class [#77](https://github.com/bebanjo/almodovar/pull/77)

## Version 1.7.8 (2022-12-14)

## Other

* Add support for batch creation api endpoints [#74](https://github.com/bebanjo/almodovar/pull/74)

## Version 1.7.7 (2020-03-16)

## Other

* Support to provide request headers based on current thread values, and bump development dependencies [#58](https://github.com/bebanjo/almodovar/pull/58)

## Version 1.7.6 (2020-03-10)

## Other

* Setup GitHub actions and remove travis [#57](https://github.com/bebanjo/almodovar/pull/57)

## Version 1.7.5 (2020-03-10)

## Other

* Bump rake from 10.1.1 to 13.0.1 [#56](https://github.com/bebanjo/almodovar/pull/56)

## Version 1.7.4 (2020-03-10)

## Other

* Bump nokogiri from 1.10.4 to 1.10.8 [#55](https://github.com/bebanjo/almodovar/pull/55)

## Version 1.7.3 (2019-08-21)

## Other

* Upgrade Nokogiri [#53](https://github.com/bebanjo/almodovar/pull/53)

## Version 1.7.2 (2019-01-05)

## Other

* Relax Nokogiri [#52](https://github.com/bebanjo/almodovar/pull/52)

## Version 1.7.1 (2018-04-16)

## Feature

* Upgrade to nokogiri to a version without vulnerabilities [#51](https://github.com/bebanjo/almodovar/pull/51)

## Version 1.7.0 (2018-01-19)

## Feature

* Remove alias_method_chain [#49](https://github.com/bebanjo/almodovar/pull/50)

## Version 1.6.0 (2017-12-27)

## Feature

* HTTPClient query parameters encoding [#49](https://github.com/bebanjo/almodovar/pull/49)

## Version 1.5.5 (2017-04-03)

## Feature

* HTTPClient force_basic_auth setting [#47](https://github.com/bebanjo/almodovar/pull/47)

## Version 1.5.4 (2016-09-07)

## Feature

* On 422 response code raise an UnprocessableEntityError instance [#45](https://github.com/bebanjo/almodovar/pull/45)

## Version 1.5.3 (2016-08-31)

## Feature

* Adding to_hash to SingleResource [#43](https://github.com/bebanjo/almodovar/pull/43)

## Version 1.5.2 (2016-04-07)

## Other

* Fix respond_to? signature to match Object signature [#39](https://github.com/bebanjo/almodovar/pull/39)
* Remove username/password validation in HttpClient [#40](https://github.com/bebanjo/almodovar/pull/40)

## Version 1.5.1 (2016-02-24)

## Other

Handle HTTPClient::TimeoutError [#37](https://github.com/bebanjo/almodovar/pull/37)

## Version 1.5.0 (2016-02-22)

## Other

Timeout refactoring [#34](https://github.com/bebanjo/almodovar/pull/34)

## Version 1.4.0 (2016-01-08)

## Other

Update Almodovar::HttpError superclass to StandardError so it can be rescued using the idiom `rescue => e` [#32](https://github.com/bebanjo/almodovar/pull/32)

## Version 1.3.0 (2015-12-21)

## Other

Avoid explicit calls to get! over Resource [#30](https://github.com/bebanjo/almodovar/pull/30)

# Almodovar Release History

## Version 1.2.0 (2015-08-14)

## Other

Implement attributes type array [#24](https://github.com/bebanjo/almodovar/pull/24)

# Almodovar Release History

## Version 1.1.2 (2014-10-16)

## Other

Upgrade httpclient dependency [#22](https://github.com/bebanjo/almodovar/pull/22)

## Version 1.1.1 (2014-09-02)

### Other

* Store response body in Almodovar::HttpError [#21](https://github.com/bebanjo/almodovar/pull/21)

## Version 1.1.0 (2014-07-12)

### Feature

* Add support for date type nodes [#20](https://github.com/bebanjo/almodovar/pull/20)

## Version 1.0.0 (2014-04-01)

### Bugfixes

* Send a proper "Content-Type" header and include session headers [#18](https://github.com/bebanjo/almodovar/pull/18)

## Version 1.0.0.pre (2014-02-11)

### Features

* Big refactor:

  * Remove serverside code, now into bebanjo/almodovar-server #15
  * Added support for paginated resources #14
  * Replaced HTTP client in favor of pure-ruby one (https://github.com/nahi/httpclient) #15

## Version 0.9.8 (2013-12-27)

### Features

* Almodovar::Resource now includes Enumerable, so we can use #select

## Version 0.9.7 (2013-11-13)

### Other

* Rollback link escaping fixes as behaviour was correct

## Version 0.9.6 (2013-11-13)

### Other

* Show prev link before next link

## Version 0.9.5 (2013-11-13)

### Bugfixes

* Fix link escaping in pagination

## Version 0.9.4 (2013-11-13)

### Bugfixes

* Don't escape link's `href` attribute

## Version 0.9.3 (2013-10-31)

### Features

* Display the URL of the resource in the error message

## Version 0.9.2 (2013-10-31)

### Other

* Use secure Rubygems server

## Version 0.9.1 (2013-08-20)

### Features

* Remove JSON tab on PresenterResource. JSON API is not fully supported

## Version 0.9.0 (2013-04-15)

### Features

* Support for custom attributes in Links

## Version 0.8.0 (2013-03-01)

### Features

* Html Serializer for Resource Presenters

## Version 0.7.0 (2012-08-10)

### Features

* Support for nesting single resources on creation

## Version 0.6.2 (2012-05-04)

### Other

* Ability to set default values for `timeout` and `connection_timeout_`

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
