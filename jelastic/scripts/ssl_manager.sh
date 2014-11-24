#!/bin/bash
#  $Id$
#  $Revision$
#  $Date$
#  $Author$
#  $HeadURL$

_SED=`which sed`;
SERVER_XML_CONFIG="/etc/httpd/conf.d/ssl.conf";

function _enableSSL(){
        local default_httpd_conf="/etc/httpd/conf/httpd.conf"
        grep -q "OPENSSL_NO_DEFAULT_ZLIB" $default_httpd_conf || echo "export OPENSSL_NO_DEFAULT_ZLIB=1" >>  $default_httpd_conf;
        local err;
        doAction keystore DownloadKeys;
        err=$?; [[ ${err} -gt 0 ]] && exit ${err};
        $_SED -i 's/SSLEngine=\"off\"/SSLEnabled=\"on\"/g' $SERVER_XML_CONFIG;
        sed -i "/^#LoadModule.*ssl_module.*/ s/^#LoadModule/LoadModule/" /etc/httpd/conf/httpd.conf ||  { writeJSONResponceErr "result=>4020" "message=>Cannot enable SSL module!"; return 4020; };
}

function _disableSSL(){
        local err;
        doAction keystore remove;
        err=$?; [[ ${err} -gt 0 ]] && exit ${err};
        $_SED -i 's/SSLEngine=\"on\"/SSLEnabled=\"off\"/g' $SERVER_XML_CONFIG;
        doAction apache2ext dismod ssl > /dev/null 2>&1 ||  { writeJSONResponceErr "result=>4021" "message=>Cannot disable SSL module!"; return 4021; };
}

