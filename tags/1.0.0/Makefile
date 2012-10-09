# Toplevel Makefile for Ruby/CLIv2

RUBY = ruby
#RUBY = C:\ruby\1.8.7\bin\ruby
#RUBY = C:\ruby\1.9\bin\ruby
WINCLIDIR = C:/Program Files/NCR/Teradata Client/cliv2

LOGON_STRING=arc/rubycli,rubycli

help:
	@echo "Usage: make (unix|win)"

unix:
	$(RUBY) setup.rb config --sodir=\$$siterubyver
	$(RUBY) setup.rb setup
	$(RUBY) setup.rb show
	@echo "Use \"$(MAKE) install\" to install."

win:
	$(RUBY) setup.rb config --sodir=$$siterubyver -- --enable-shared --with-cli-include="$(WINCLIDIR)/inc" --with-cli-lib="$(WINCLIDIR)/lib"
	$(RUBY) setup.rb setup
	$(RUBY) setup.rb show
	@echo "Use \"$(MAKE) install\" to install."

install:
	$(RUBY) setup.rb install

clean:
	$(RUBY) setup.rb clean

distclean:
	$(RUBY) setup.rb distclean

test:
	TEST_LOGON_STRING=$(LOGON_STRING) $(RUBY) test/all
