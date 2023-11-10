all:
	$(MAKE) build
	$(MAKE) asterisk

build:
	@$(MAKE) /build/build

/build/build:
	$(RM) -r /tmpbuild/build && mkdir -p /tmpbuild/build
	cd /tmpbuild/build && curl -L -o asterisk.tgz https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-20-current.tar.gz
	cd /tmpbuild/build && mkdir tmp
	cd /tmpbuild/build && tar xf asterisk.tgz -C tmp --strip-components 1
	mkdir -p /build
	mv /tmpbuild/build /build
	$(RM) -r /tmpbuild

asterisk:
	@$(MAKE) /build/build/asterisk

/build/build/asterisk:
	cd /build/build/tmp && ./configure --with-pjproject-bundled --with-jansson-bundled
	cd /build/build/tmp && $(MAKE) menuselect.makeopts
	cd /build/build/tmp && menuselect/menuselect \
		--disable BUILD_NATIVE \
		--enable chan_mobile \
		--disable chan_ooh323 \
		--enable format_mp3 \
		--enable-category MENUSELECT_APPS \
		--disable app_skel \
		--disable app_ivrdemo \
		--disable app_saycounted \
		--disable app_statsd \
		--enable-category MENUSELECT_BRIDGES \
		--enable-category MENUSELECT_CDR \
		--disable cdr_pgsql \
		--disable cdr_radius \
		--disable cdr_custom \
		--disable cdr_csv \
		--disable cdr_sqlite3_custom \
		--enable-category MENUSELECT_CEL \
		--disable cel_pgsql \
		--disable cel_radius \
		--disable cel_custom \
		--disable cel_manager \
		--disable cel_sqlite3_custom \
		--enable-category MENUSELECT_CHANNELS \
		--enable-category MENUSELECT_CODECS \
		--enable-category MENUSELECT_FORMATS \
		--enable-category MENUSELECT_FUNCS \
		--enable-category MENUSELECT_PBX \
		--enable pbx_lua \
		--enable-category MENUSELECT_RES \
		--disable res_mwi_external \
		--disable res_chan_stats \
		--disable res_endpoint_stats \
		--disable res_pktccops \
		--enable-category MENUSELECT_TESTS \
		--enable-category MENUSELECT_UTILS \
		--disable aelparse \
		--disable astman \
		--disable check_expr \
		--disable check_expr2 \
		--disable smsq \
		--disable stereorize \
		--enable  streamplayer \
		--disable astdb2sqlite3 \
		--disable astdb2bdb \
		--disable-category MENUSELECT_AGIS \
		--disable-category MENUSELECT_CORE_SOUNDS \
		--enable CORE-SOUNDS-EN-ULAW \
		--disable-category MENUSELECT_MOH \
		--enable MOH-OPSOUND-ULAW \
		--disable-category MENUSELECT_EXTRA_SOUNDS \
		--enable EXTRA-SOUNDS-EN-ULAW \
		menuselect.makeopts
	cd /build/build/tmp && $(MAKE) -j $(nproc)
	cd /build/build/tmp && sh contrib/scripts/get_mp3_source.sh
	cd /build/build/tmp && $(MAKE) install
	mv /build/build/tmp /build/build/asterisk
	cd /build/build/asterisk && $(MAKE) install
	$(RM) /usr/lib/asterisk/modules/res_pjsip_transport_websocket.so
	cd build/build/asterisk && $(MAKE) samples
	mkdir -p /usr/share
	$(RM) -r /usr/share/asterisk
	mv /etc/asterisk/ /usr/share
	mkdir /etc/asterisk
	cd /usr/lib/asterisk/modules && $(RM) res_monitor.so chan_mgcp.so chan_skinny.so res_adsi.so app_adsiprog.so app_getcpeid.so app_macro.so

clean:
	$(RM) -r /build
