# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))
require 'data_objects/spec/connection_spec'
require 'cgi'

describe DataObjects::Mysql::Connection do

  before do
    @driver   = CONFIG.scheme
    @user     = CONFIG.user
    @password = CONFIG.pass
    @host     = CONFIG.host
    @port     = CONFIG.port
    @database = CONFIG.database
    @ssl      = CONFIG.ssl
  end

  behaves_like 'a Connection'
  behaves_like 'a Connection with authentication support'
  # FIXME: behaves_like 'a Connection with JDBC URL support' if JRUBY
  behaves_like 'a Connection with SSL support' unless JRUBY
  behaves_like 'a Connection via JDNI' if JRUBY

  if DataObjectsSpecHelpers.test_environment_supports_ssl?

    describe 'connecting with SSL' do

      it 'should raise an error when passed ssl=true' do
        lambda { DataObjects::Connection.new("#{CONFIG.uri}?ssl=true") }.
          should.raise(ArgumentError)
      end

      it 'should raise an error when passed a nonexistent client certificate' do
        lambda { DataObjects::Connection.new("#{CONFIG.uri}?ssl[client_cert]=nonexistent") }.
          should.raise(ArgumentError)
      end

      it 'should raise an error when passed a nonexistent client key' do
        lambda { DataObjects::Connection.new("#{CONFIG.uri}?ssl[client_key]=nonexistent") }.
          should.raise(ArgumentError)
      end

      it 'should raise an error when passed a nonexistent ca certificate' do
        lambda { DataObjects::Connection.new("#{CONFIG.uri}?ssl[ca_cert]=nonexistent") }.
          should.raise(ArgumentError)
      end

      it 'should connect with a specified SSL cipher' do
        DataObjects::Connection.new("#{CONFIG.uri}?#{CONFIG.ssl}&ssl[cipher]=#{SSLHelpers::CONFIG.cipher}").
          ssl_cipher.should == SSLHelpers::CONFIG.cipher
      end

      it 'should raise an error with an invalid SSL cipher' do
        lambda { DataObjects::Connection.new("#{CONFIG.uri}?#{CONFIG.ssl}&ssl[cipher]=invalid") }.
          should.raise
      end

    end

  end

end
