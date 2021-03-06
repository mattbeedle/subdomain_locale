require_relative "test_helper"

class UrlForTest < ActiveSupport::TestCase
  module UrlFor
    def url_for(*args)
      args
    end
  end

  include UrlFor
  include SubdomainLocale::UrlFor

  def subdomain_locales
    @mapping ||= Object.new.tap do |mapping|
      def mapping.subdomain_for(locale)
        "ru" if locale == :ru
      end
    end
  end

  def current_locale
    :ru
  end

  def test_no_locale
    @actual = url_for(foo: 'bar')
    assert_equal [{foo: 'bar'}], @actual
  end

  def test_locale
    @actual = url_for(foo: 'bar', locale: :ru)
    assert_equal [{foo: 'bar', subdomain: 'ru', only_path: false}], @actual
  end

  def test_hash_immutable
    orig_params = { foo: 'bar', locale: :ru }
    params = orig_params.dup.freeze
    url_for(params)
    assert_equal orig_params, params
  end
end
