### **1. First Create Docker Machine with proper PROXY settings, if necessary!**
```
docker-machine create -d virtualbox \
    --engine-env HTTP_PROXY=http://http.proxy.domain.com:8000 \
    --engine-env HTTPS_PROXY=http://http.proxy.domain.com:8000 \
    --engine-env NO_PROXY=example2.com \
    dev
```    
**machine == dev**
### **2. Running docker on host machine**

You need to set this variable in order for docker command to work on host machine.
```
docker-machine env dev
```

```
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH="/Users/aXXXXX/.docker/machine/machines/dev"
export DOCKER_MACHINE_NAME="dev"
# Run this command to configure your shell:
# eval "$(docker-machine env dev)" 
``` 

Run this command as well, this will enable Docker command to work on host within proxy
```
export NO_PROXY=192.168.99.100
```


### **3. Build data image and container first**
```
cd Docker/Docker_data_container/
docker build -t data .
docker run --name=DATA -d data
```

### **4. Build application image and container second**
```
// move up the directory tree, into Docker directory
cd ../
docker build -t app .
docker run -i -t --volumes-from=DATA -p 3306:3306 -p 3000:3000 -p 27017:27017 -p 35729:35729 --name=APP -v /Users:/Users -d app
```

### **5. After installation all is complete with no errors**
```
docker exec -it APP bash
```
*this will bring up the bash*
### **If you need to remove images or containers**
```
docker rmi -f **image name**
docker rm -f **container name**
```
#### **List of installations**

1. Mysql 
⋅⋅* -- Root user and permission are also defined -- Possible to dump DB as well
2. MongoDB
3. Python 2.7.9
4. Ruby
5. Node.js & NPM
6. Node.js Orecla Driver
7. Global NPMs
⋅⋅* gulp
⋅⋅* pm2
⋅⋅* grunt-cli
⋅⋅* grunt
⋅⋅* nodemon
⋅⋅* oracledb

#### **Delete all containers**
```
docker rm $(docker ps -a -q)
```
#### **Delete all images**
```
docker rmi $(docker images -q)
```
