#!/bin/sh

function _set_neighbors(){
    return 0;
}

function _rebuild_common(){
    sudo /etc/init.d/httpd reload >> /dev/null
}

function _add_common_host(){
    grep -q "${host}" /etc/httpd/conf/virtualhosts.conf && return 0;
    host_num=`cat /etc/httpd/conf/virtualhosts_http.conf|grep BalancerMember | awk '{print $3}' | sed 's/route=//g | sort';
    let "host_num+=1";
    sed -i '/<Proxy balancer:\/\/myclusterhttp>/a BalancerMember http:\/\/'${host}' route='${host_num}'' /etc/httpd/conf/virtualhosts_http.conf;
    sed -i '/<Proxy balancer:\/\/myclusterajp>/a BalancerMember ajp:\/\/'${host}':8009' /etc/httpd/conf/virtualhosts_ajp.conf;
    sed -i '/<Proxy balancer:\/\/myclusterajp>/a BalancerMember ajp:\/\/'${host}':8009' /etc/httpd/conf/virtualhosts_jk.conf;
    grep -q "${host}" /opt/shared/conf.d/ssl.conf && return 0;
    sed -i '/<Proxy balancer:\/\/myclusterhttps>/a BalancerMember http:\/\/'${host}' route='${host_num}'' /opt/shared/conf.d/ssl.conf;
}



function _remove_common_host(){
   sed -i '/'${host}'/d' /etc/httpd/conf/virtualhosts_http.conf;
   sed -i '/'${host}'/d' /etc/httpd/conf/virtualhosts_ajp.conf;
   sed -i '/'${host}'/d' /etc/httpd/conf/virtualhosts_jk.conf;
   sed -i '/'${host}'/d' /opt/shared/conf.d/ssl.conf;
}


function _add_host_to_group(){
    return 0;
}

function _build_cluster(){
    return 0;
}

function _unbuild_cluster(){
    return 0;
}

function _clear_hosts(){
    return 0;
}

function _reload_configs(){
    return 0;
}

