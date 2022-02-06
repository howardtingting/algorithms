TO run hack prog in CLI:
$ hhvm {hackfile}.php

TO serve file on port:
$ hhvm -m server -p ${PORT}

TO run in docker:
$ docker container run --name ${ARBITRARYNAME} -p ${OUTERPORT}:${INNERPORT}

DEBUGGING:
TO check code pre-compile
$ hh_client . #run with directory hack/ as root

TO lint code:
# create hhast-lint.json: see hack/main/hhast-lint.json
$ vendor/bin/hhast-lint