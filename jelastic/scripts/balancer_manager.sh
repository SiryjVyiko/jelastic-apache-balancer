#!/bin/sh

function _set_neighbors(){
    return 0;
}

function _rebuild_common(){
    sudo /etc/init.d/httpd reload
}

function _add_common_host(){
    sed -i '/<Proxy balancer://myclusterhttp>/a BalancerMember http://${host}' /etc/httpd/conf/virtualhosts.conf;
    sed -i '/<Proxy balancer://myclusterhttps>/a BalancerMember https://${host}' /etc/httpd/conf/virtualhosts.conf;
    sed -i '/<Proxy balancer://myclusterajp>/a BalancerMember ajp://${host}:8009' /etc/httpd/conf/virtualhosts.conf;
}



function _remove_common_host(){
   sed -i '/'${host}'/d' /etc/httpd/conf/virtualhosts.conf;
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

