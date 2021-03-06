[buildout]
extends = http://pythonpackages.com/buildout/plone/3.3.x
parts = 
    bootstrap
    supervisor
    varnish
    varnish-conf
    instance
    plonesite

[bootstrap]
recipe = collective.recipe.bootstrap

[varnish]
recipe = zc.recipe.cmmi
url = http://sourceforge.net/projects/varnish/files/varnish/2.0.6/varnish-2.0.6.tar.gz/download

[supervisor]
recipe = collective.recipe.supervisor
port = ${ports:supervisor}
serverurl = http://${hosts:localhost}:${ports:supervisor}
programs =
    0 varnish ${varnish:location}/sbin/varnishd [-f ${varnish-conf:output} -a ${varnish-conf:bind} -s ${varnish-conf:storage} -T ${ports:varnish-manage} -F]

[ports]
varnish = 8080
instance = 8081
supervisor = 8082
varnish-manage = 8083

[hosts]
localhost = 127.0.0.1

[varnish-conf]
recipe = collective.recipe.template
input = http://pythonpackages.com/buildout/plone-varnish/conf/varnish.vcl.in
output = ${buildout:directory}/etc/varnish.vcl
bind = ${hosts:localhost}:${ports:varnish}
storage = file,${varnish:location}/storage,1G

[plonesite]
recipe = collective.recipe.plonesite
