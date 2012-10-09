= Ruby/CLIv2 User Manual

== Usage Examples

Example 1: Connecting dbc and fetching all records of the table x.
Session charset is UTF-8 by default.

  require 'teradata'
  require 'pp'

  Teradata.connect("dbc/test,test") {|conn|
    pp conn.entries("select * from x;")   # fetch and show all records
  }

Example 2: Processing for each records of the table x.

  require 'teradata'

  Teradata.connect("dbc/test,test") {|conn|
    conn.query("select * from x;") {|result_set|
      result_set.each_record do |rec|
        p rec        # => #<Record (x "a "), (y "455   ")>
        p rec.to_a   # => ["a ", "455   "]
        p rec[:x]    # => "a "
        p rec[0]     # => "a "
      end
    }
  }

Example 3: Handling multi-statement request (multiple result sets).

  require 'teradata'

  Teradata.connect("dbc/test,test") {|conn|
    conn.query("select * from x;") {|result_sets|
      result_sets.each_result_set do |rs|
        pp rs.entries   # fetch and show all records at once
      end
    }
  }

Example 4: Specifiying a session charset.

  require 'teradata'

  Teradata.connect('dbc/test,test', :session_charset => 'KanjiSJIS_0S') {|conn|
    p conn.entries('select * from x;')
  }


== class Teradata::Connection

Teradata::Connection object represents a Teradata session.

=== Singleton Methods

--- new(logon_string, options = {}) -> Teradata::Connection
--- new(logon_string, options = {}) {|conn| .... }
--- open(logon_string, options = {}) -> Teradata::Connection
--- open(logon_string, options = {}) {|conn| .... }

Creates a new Connection object and establishes Teradata session.
logon_string is a string like "dbc/user,password,'acct'".
TDP-ID and accout string are optional.

options is a Hash object and it accepts following keys.

  * :session_charset (a String object like "KANJISJIS_0S")
  * :internal_encoding (an Encoding object)
  * :logger (a Logger object or method-compatible object)

If this method is called with a block, this method yields
an opened Connection object to the block.  A connection
is automatically closed after the block exits.

=== Instance Methods

--- close

Closes this connection.
Previously opened result sets are also closed automatically.

Closing already closed Connection object causes Teradata::CLIError.

--- update(sql) -> Teradata::ResultSet
--- execute_update(sql) -> Teradata::ResultSet

Executes SQL string sql and returns the result set.
This method expects the given SQL does not return any record.

For multi-statement request, result set may include multiple
ResultSet objects.

--- query(sql) {|rs| ... }
--- execute_query(sql) {|rs| ... }

Executes SQL string sql and returns the result set.  You can use
this method for any kind of SQL, with or without result records.

For multi-statement request, result set may consist of multiple
ResultSet objects.


== class Teradata::ResultSet

include Enumerable

Teradata::ResultSet object represents SQL result.
It is consists of status codes, messages, and result records of query.

For multi-statement request, ResultSet object may consist of multiple
result set.  Multiple result sets are maintained as linked list
internally.

=== Instance Methods

--- error_code -> Integer

SQL error code.

--- info -> Integer

SQL error information code.

--- message -> String

Success or failure message.

--- statement_no -> Integer

Statement number.

--- activity_count -> Integer

Number of returned records.

--- n_fields -> Integer

Number of fields of a returned record.

--- warning_code -> Integer

Warning code.
If there is no warning, this method returns 0.

--- next -> Teradata::ResultSet

Returns the next result set object.
If this ResultSet is the final result set, returns nil.

--- each_result_set {|rs| .... }

Iterates for all result sets, beginning with receiver.
This method closes this ResultSet after the block is returned.

You can use this method for also singleton result set.

--- each_records {|rec| .... }
--- each {|rec| .... }

Fetches result records one by one and gives it to the block.
A record is a Teradata::Record object.
This method closes this ResultSet after processing all records.

@raise Teradata::ConnectionError
    This method is called for already closed ResultSet.

--- entries -> [Teradata::Record]

Fetches all result records and return them as an Array.

@raise Teradata::ConnectionError
    This method is called for already closed ResultSet.

--- close

Closes this result set.
You cannot access result records after the result set is closed.

Only exception is that you called ResultSet#execute_query without
block.  ResultSet#execute_query read all records and keep them
internally, you can get them by ResultSet#entries regardless of
ResultSet status.

--- inspect -> String

Returns a descriptive string.


== class Teradata::Record

include Enumerable

=== Instance Methods

--- size -> Integer

Number of fields.

--- [](name) -> String | Integer | Time
--- [](index) -> String | Integer | Time

Returns a field value.

--- field(name) -> Teradata::Field
--- field(index) -> Teradata::Field

Returns a field.

--- each_field {|f| ... }

Iterates for each fields.

--- each_value {|val| ... }
--- each {|val| ... }

Iterates for each field values.

--- to_a -> [Object]

Returns a set of field values.


== class Teradata::Field

=== Instance Methods

--- value -> String | Integer | Time
--- data  -> String | Integer | Time

A field data.

NULL is given as nil.

CHAR, VARCHAR, TIME, TIMESTAMP, BYTE, VARBYTE are given as a String.

BYTEINT, SHORTINT, INT, BIGINT are given as an Integer.

DATE are given as a Time, with 00:00:00.0 time.

DECIMAL is given as a String now, but should as an BigDecimal in future.

--- name -> String

A field name.
Note that a field name may be empty string.

--- format -> String

A field format string.

--- title -> String

A field title.

--- type -> String

CLI type name of this field (e.g. "INTEGER_NN").

--- type_code

CLI type code of this field (e.g. 487).

--- null?

Returns true if this field is NULL.
