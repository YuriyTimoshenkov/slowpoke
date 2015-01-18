PROJECT = slowpoke

DEPS = cowboy jiffy
dep_cowboy = git https://github.com/extend/cowboy.git master
dep_jiffy = git https://github.com/davisp/jiffy.git master

include erlang.mk
