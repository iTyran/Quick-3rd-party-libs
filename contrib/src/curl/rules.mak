# curl

CURL_VERSION := 7.52.1
CURL_URL :=  http://curl.haxx.se/download/curl-$(CURL_VERSION).tar.gz

$(TARBALLS)/curl-$(CURL_VERSION).tar.gz:
	$(call download,$(CURL_URL))

.sum-curl: curl-$(CURL_VERSION).tar.gz

curl: curl-$(CURL_VERSION).tar.gz .sum-curl
	$(UNPACK)
	$(UPDATE_AUTOCONFIG)
	$(MOVE)

DEPS_curl = zlib $(DEPS_zlib)

DEPS_curl = openssl $(DEPS_openssl)

ifdef HAVE_LINUX
configure_option=--without-libidn --without-librtmp
endif

ifdef HAVE_TVOS
configure_option+=--disable-ntlm-wb
endif

.curl: curl .zlib .openssl
	$(APPLY) $(SRC)/curl/connectx.patch
	$(RECONF)
	cd $< && $(HOSTVARS_PIC) ./configure $(HOSTCONF) \
		--with-ssl=$(PREFIX) \
		--with-zlib \
		--enable-ipv6 \
		--disable-ldap \
		$(configure_option)
	cd $< && $(MAKE) install
	touch $@
