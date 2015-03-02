require_relative 'openfoodfacts/product'
require_relative 'openfoodfacts/version'

require 'json'
require 'nokogiri'
require 'open-uri'

module Openfoodfacts
  DEFAULT_LOCALE = 'world'

  class << self

    # Return ocale from link
    def locale_from_link(link)
      link[/^https?:\/\/([^.]+)\./i, 1]
    end

    # Get locales
    #
    def locales
      url = "http://openfoodfacts.org/"
      body = open(url).read
      dom = Nokogiri.parse(body)

      dom.css('ul li a').map { |locale_link|
        locale_from_link(locale_link.attr('href'))
      }.uniq.sort
    end

    # Get product
    #
    def product(barcode, locale: DEFAULT_LOCALE)
      Product.get(barcode, locale)
    end

    # Return product API URL
    #
    def product_url(barcode, locale: DEFAULT_LOCALE)
      Product.url(barcode, locale)
    end

    # Search products 
    #
    def product_search(terms, locale: DEFAULT_LOCALE, page: 1, page_size: 20, sort_by: 'unique_scans_n')
      Product.search(terms, locale: locale, page: page, page_size: page_size, sort_by: sort_by)
    end

  end
end