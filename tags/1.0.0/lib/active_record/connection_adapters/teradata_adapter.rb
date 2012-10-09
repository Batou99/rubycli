require 'active_record/connection_adapters/abstract_adapter'

module ActiveRecord

  class Base

    def self.teradata_connection(config) # :nodoc:
      require_library_or_gem 'teradata' unless defined?(Teradata)
      config = config.symbolize_keys
      tdpid = config[:tdpid]
      user = config[:username]
      pass = config[:password]
      account = config[:account]
      charset = config[:charset]
      logon_string = Teradata::LogonString.new(tdpid, user, pass, account)
      ConnectionAdapters::TeradataAdapter.new(logger, logon_string, config)
    end

  end

  module ConnectionAdapters

    class TeradataAdapter < AbstractAdapter

      def initialize(logger, logon_string, config)
        @logon_string = logon_string
        @charset = config[:charset]
        @config = config
        connect
        super @connection, logger
      end

      def adapter_name   #:nodoc:
        'Teradata'
      end

      def connect
        @connection = Teradata::Connection.open(@logon_string, @charset)
      end
      private :connect

      #def supports_migrations?   #:nodoc:
      
      def supports_savepoints?   #:nodoc:
        true
      end

      def native_database_types   #:nodoc:
        {
          :primary_key => 'INTEGER PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY',
          :string => { :name => "VARCHAR", :limit => 255 },
          :integer => { :name => "INTEGER" },
          :date => { :name => "DATE" }
        }
      end

      # QUOTING ==================================================

      #def quote(value, column = nil)

      def quote_column_name(name) #:nodoc:
        %Q("#{name}")
      end

      def quote_string(string) #:nodoc:
        @connection.quote(string)
      end

      # REFERENTIAL INTEGRITY ====================================

      #def disable_referential_integrity(&block) #:nodoc:

      # CONNECTION MANAGEMENT ====================================

      def active?
        @connection.execute_query('SELECT 1')
        true
      rescue Teradata::CLI::Error
        false
      end

      def reconnect!
        disconnect!
        connect
      end

      def disconnect!
        @connection.close
      rescue Teradata::CLI::Error
        ;
      end

      def reset!
        reconnect!
      end

      # DATABASE STATEMENTS ======================================

      def select_rows(sql, name = nil)
        log(sql, name) {
          @connection.entries(sql)
        }
      end

      def execute_update(sql, name = nil)   #:nodoc:
        log(sql, name) {
          @connection.execute_update(sql)
        }
      end

      def begin_db_transaction   #:nodoc:
        execute_update "BEGIN TRANSACTION"
      end

      def commit_db_transaction #:nodoc:
        execute_update "COMMIT"
      end

      def rollback_db_transaction #:nodoc:
        execute_update "ROLLBACK"
      end

      def create_savepoint
        execute_update "SAVEPOINT #{current_savepoint_name}"
      end

      def rollback_to_savepoint
        execute_update "ROLLBACK TO SAVEPOINT #{current_savepoint_name}"
      end

      def release_savepoint
        execute_update "RELEASE SAVEPOINT #{current_savepoint_name}"
      end

      def select(sql, name = nil)
        @connection.execute_query(sql).map {|rec|
          h = {}
pp rec
          rec.each_field do |f|
            h[f.name] = f.value
          end
pp h
          h
        }
      end

      def supports_views?
        true
      end

      def version
        '1.0.0'
      end

      def tables(name = nil)
        # FIXME: fetch metadata from database
        ['shohins']
      end

      def columns(table, name = nil)
        # FIXME: fetch metadata from database
        [
          TeradataColumn.new('id', :integer),
          TeradataColumn.new('shohin_code', :string),
          TeradataColumn.new('shohin_name', :string)
        ]
      end

      def column_for(table, column)
        cname = column.to_s
        col = columns(table).detect {|c| c.name == cname }
        raise "No such column: #{table}.#{column}" unless col
        col
      end

    end

    # FIXME: wrap Metadata
    class TeradataColumn
      def initialize(name, type)
        @name = name
        @type = type
      end

      attr_reader :name
      attr_reader :type
      attr_accessor :primary

      def text?
        @type == :string
      end

      def number?
        @type == :integer
      end

      def type_cast(v) v end
    end

  end

end
