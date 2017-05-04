:: === set env vars required for docker
@FOR /f "tokens=*" %i IN ('docker-machine env --shell cmd') DO @%i

:: === start tensorflow
:: make sure the folder is configured as shared folder in virtualbox (carnd -> C:\projects\udacity-carnd)
docker run -it -p 8888:8888 -v //carnd:/notebooks/carnd gcr.io/tensorflow/tensorflow:1.0.1-py3

:: === attach bash to running container
:: 1) get container id via: docker container ls
:: 2) run bash in container: docker exec -i -t 108c2c80f1bc /bin/bash

:: === mount a directory from windows
:: 1) create a shared path in virtual box to the windows directory you want to mount
:: 2) ssh into docker container (see above)

