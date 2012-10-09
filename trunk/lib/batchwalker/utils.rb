# $Id: utils.rb 7 2010-03-04 16:54:09Z tdaoki $

require 'teradata'
require 'batchwalker/credentialstorage'

module BatchWalker

  def BatchWalker.logon(key, &block)
    logon_string = CredentialStorage.load_default[key]
    Teradata::Connection.open(logon_string, &block)
  end

end
