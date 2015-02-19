all:
	@echo "This doesn't really do anything. Run make test or make install."
clean:
	@echo "Nothing to clean. Did you mean make uninstall?"
test:
	./test.sh
install: test
	install -m 755 kilopass.sh /usr/local/bin/kilopass
uninstall:
	rm /usr/local/bin/kilopass
