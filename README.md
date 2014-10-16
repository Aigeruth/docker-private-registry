# DockerRegistry

[![Build Status](http://img.shields.io/travis/Aigeruth/docker-private-registry.svg)][travis]
[![Coverage](http://img.shields.io/coveralls/Aigeruth/docker-private-registry.svg)][coveralls]
[![Code Climate](http://img.shields.io/codeclimate/github/Aigeruth/docker-private-registry.svg)][codeclimate]
[![Dependency Status](http://img.shields.io/gemnasium/Aigeruth/docker-private-registry.svg)][gemnasium]

[travis]: http://travis-ci.org/Aigeruth/docker-private-registry
[coveralls]: https://coveralls.io/r/Aigeruth/docker-private-registry
[codeclimate]: https://codeclimate.com/github/Aigeruth/docker-private-registry
[gemnasium]: https://gemnasium.com/Aigeruth/docker-private-registry

Docker Registry implemented in Ruby.

* [Demo](http://docker-private-registry.herokuapp.com)
* [API docs](http://docker-private-registry.herokuapp.com/swagger)

Components:

* [Sinatra](http://www.sinatrarb.com/)
* [Grape](http://intridea.github.io/grape/)

## Use-cases

* If you have limited outgoing bandwidth.
* If you have some trust issues with using cloud-based services.
* You still want to use Docker and distribute images.

Propably a good choice to setup your own Docker Registry on your local network.

## Install

Requirements:

* Ruby 2.1.3
* [Bundler](http://bundler.io/)

Clone the repository and install the dependencies with `bundler`:

```bash
git clone http://github.com/Aigeruth/docker-private-registry.git
cd docker-private-registry
bundle install --jobs 4 --without development test lint
```
## Usage

Start the repository server:

```bash
$ cp config.yml.sample config.yml
$ bundle exec unicorn -c unicorn.rb
```

Or you can start it in a Docker container:

```bash
$ cp config.yml.sample config.yml
$ docker build -t docker-private-registry .
$ docker run -ti --name registry docker-private-registry
```

Or you can pull the image from [Docker Hub](https://hub.docker.com/)

```bash
docker pull aige/docker-private-registry
```

Now you need an image that you can push to the repository.

**Note:** image name must contain the Docker Registry host and port (if it is different from 80 or 443).

You can find a `Dockerfile` in the `spec/fixtures/repository/test/scratch` directory:

```bash
$ docker build -t '192.168.59.3:9292/test/scratch' spec/fixtures/repositories/test/scratch
Sending build context to Docker daemon  2.56 kB
Sending build context to Docker daemon
Step 0 : FROM scratch
Pulling repository scratch
511136ea3c5a: Download complete
 ---> 511136ea3c5a
Step 1 : MAINTAINER User <test@example.com>
 ---> Running in 87bf99061c81
 ---> a8771b8841e2
Removing intermediate container 87bf99061c81
Successfully built a8771b8841e2
```

Now you have an image that you can push:

```bash
$ docker images
REPOSITORY                       TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
192.168.59.3:9292/test/scratch   latest              a8771b8841e2        2 hours ago         0 B
scratch                          latest              511136ea3c5a        13 months ago       0 B
$ docker push 192.168.59.3:9292/test/scratch
The push refers to a repository [192.168.59.3:9292/test/scratch] (len: 1)
Sending image list
Pushing repository 192.168.59.3:9292/test/scratch (1 tags)
511136ea3c5a: Image successfully pushed
a8771b8841e2: Image successfully pushed
Pushing tag for rev [a8771b8841e2] on {http://192.168.59.3:9292/v1/repositories/test/scratch/tags/latest}
```

You should see something like this in the HTTP server log:

```http
192.168.59.103 - - [19/Jul/2014 01:56:51] "GET /v1/_ping HTTP/1.1" 200 19 0.1341
192.168.59.103 - - [19/Jul/2014 01:56:51] "PUT /v1/repositories/test/scratch HTTP/1.1" 200 79 0.0072
192.168.59.103 - - [19/Jul/2014 01:56:51] "GET /v1/images/511136ea3c5a64f264b78b5433614aec563103b4d4702f3ba7d4d2698e22c158/json HTTP/1.1" 404 519 0.0194
192.168.59.103 - - [19/Jul/2014 01:56:51] "PUT /v1/images/511136ea3c5a64f264b78b5433614aec563103b4d4702f3ba7d4d2698e22c158/json HTTP/1.1" 200 524 0.0030
192.168.59.103 - - [19/Jul/2014 01:56:51] "PUT /v1/images/511136ea3c5a64f264b78b5433614aec563103b4d4702f3ba7d4d2698e22c158/layer HTTP/1.1" 200 - 0.0049
192.168.59.103 - - [19/Jul/2014 01:56:51] "PUT /v1/images/511136ea3c5a64f264b78b5433614aec563103b4d4702f3ba7d4d2698e22c158/checksum HTTP/1.1" 200 - 0.0020
192.168.59.103 - - [19/Jul/2014 01:56:51] "GET /v1/images/a8771b8841e2a4cb0d090b11895fff2c6325c211aaf36082eafdf52412377183/json HTTP/1.1" 404 519 0.0026
192.168.59.103 - - [19/Jul/2014 01:56:51] "PUT /v1/images/a8771b8841e2a4cb0d090b11895fff2c6325c211aaf36082eafdf52412377183/json HTTP/1.1" 200 1585 0.0036
192.168.59.103 - - [19/Jul/2014 01:56:51] "PUT /v1/images/a8771b8841e2a4cb0d090b11895fff2c6325c211aaf36082eafdf52412377183/layer HTTP/1.1" 200 - 0.0049
192.168.59.103 - - [19/Jul/2014 01:56:52] "PUT /v1/images/a8771b8841e2a4cb0d090b11895fff2c6325c211aaf36082eafdf52412377183/checksum HTTP/1.1" 200 - 0.0019
192.168.59.103 - - [19/Jul/2014 01:56:52] "PUT /v1/repositories/test/scratch/tags/latest HTTP/1.1" 200 2 0.0024
```

You can find it in the `storage` directory:

```bash
$ ls storage/images storage/repositories/test/*
storage/images:
511136ea3c5a64f264b78b5433614aec563103b4d4702f3ba7d4d2698e22c158
a8771b8841e2a4cb0d090b11895fff2c6325c211aaf36082eafdf52412377183

storage/repositories/test/scratch:
json tags
```

Lets remove it, than pull it from the registry:

```bash
$ docker rmi -f $(docker images -q)
Untagged: 192.168.59.3:9292/test/scratch:latest
Deleted: a8771b8841e2a4cb0d090b11895fff2c6325c211aaf36082eafdf52412377183
Untagged: scratch:latest
Deleted: 511136ea3c5a64f264b78b5433614aec563103b4d4702f3ba7d4d2698e22c158
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
$ docker pull 192.168.59.3:9292/test/scratch
Pulling repository 192.168.59.3:9292/test/scratch
a8771b8841e2: Download complete
511136ea3c5a: Download complete
$ docker images
REPOSITORY                       TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
192.168.59.3:9292/test/scratch   latest              a8771b8841e2        2 hours ago         0 B
```

You should see something like this in the HTTP server log:

```http
192.168.59.103 - - [19/Jul/2014 01:57:22] "GET /v1/_ping HTTP/1.1" 200 19 0.0019
192.168.59.103 - - [19/Jul/2014 01:57:22] "GET /v1/repositories/test/scratch/images HTTP/1.1" 200 149 0.0031
192.168.59.103 - - [19/Jul/2014 01:57:22] "GET /v1/repositories/test/scratch/tags HTTP/1.1" 200 77 0.0024
192.168.59.103 - - [19/Jul/2014 01:57:22] "GET /v1/images/a8771b8841e2a4cb0d090b11895fff2c6325c211aaf36082eafdf52412377183/ancestry HTTP/1.1" 200 135 0.0023
192.168.59.103 - - [19/Jul/2014 01:57:22] "GET /v1/images/511136ea3c5a64f264b78b5433614aec563103b4d4702f3ba7d4d2698e22c158/json HTTP/1.1" 200 483 0.0023
192.168.59.103 - - [19/Jul/2014 01:57:22] "HEAD /v1/images/511136ea3c5a64f264b78b5433614aec563103b4d4702f3ba7d4d2698e22c158/layer HTTP/1.1" 200 - 0.0031
192.168.59.103 - - [19/Jul/2014 01:57:22] "GET /v1/images/511136ea3c5a64f264b78b5433614aec563103b4d4702f3ba7d4d2698e22c158/layer HTTP/1.1" 200 87 0.0024
192.168.59.103 - - [19/Jul/2014 01:57:22] "GET /v1/images/a8771b8841e2a4cb0d090b11895fff2c6325c211aaf36082eafdf52412377183/json HTTP/1.1" 200 1499 0.0028
192.168.59.103 - - [19/Jul/2014 01:57:22] "HEAD /v1/images/a8771b8841e2a4cb0d090b11895fff2c6325c211aaf36082eafdf52412377183/layer HTTP/1.1" 200 - 0.0020
192.168.59.103 - - [19/Jul/2014 01:57:22] "GET /v1/images/a8771b8841e2a4cb0d090b11895fff2c6325c211aaf36082eafdf52412377183/layer HTTP/1.1" 200 181 0.0024
```

## Limitations

* Supports only Docker 1.2.0 or newer clients
* Supports only local storage backend
* No authentication
* No authorization
* No streaming for uploads and downloads

## Implemented routes

Visit the [API docs](http://docker-private-registry.herokuapp.com/swagger) or

```bash
     GET        /:version/_ping
     GET        /:version/repositories/:namespace/:repository
     PUT        /:version/repositories/:namespace/:repository
     DELETE     /:version/repositories/:namespace/:repository
     GET        /:version/repositories/:namespace/:repository/images
     PUT        /:version/repositories/:namespace/:repository/images
     GET        /:version/repositories/:namespace/:repository/tags
     PUT        /:version/repositories/:namespace/:repository/tags/:tag
     GET        /:version/images/:image_id/json
     PUT        /:version/images/:image_id/json
     HEAD       /:version/images/:image_id/layer
     GET        /:version/images/:image_id/layer
     PUT        /:version/images/:image_id/layer
     PUT        /:version/images/:image_id/checksum
     GET        /:version/images/:image_id/ancestry
```

## Development

Starting the Docker Repository:

```bash
git clone
bundle install
bundle exec rerun 'unicorn -p 9292'
```

Creating container for testing:

```bash
docker build -t '127.0.0.1:9292/test/scratch' spec/fixtures/repositories/test/scratch
```

If you use Mac OS X and Boot2Docker, you have to use the VirtualBox IP
address in the tag (e.g. `192.168.59.3`), because Docker determinates the
host of the registry from the tag.

```bash
docker build -t '192.168.59.3:9292/test/scratch' spec/fixtures/repositories/test/scratch
```

Pushing the new image: `docker push 127.0.0.1:9292/test/scratch`

### Running tests

#### Unit tests

You can run the RSpec tests with `rake`:

```bash
bundle exec rake spec
```

#### Integration tests

You can run the Vagrant based integration test like this:

```bash
bundle exec rake spec:integration
```

Intragration test requires:

* [VirtualBox](http://virtualbox.org/)
* [Vagrant](http://www.vagrantup.com/) 1.6 or newer
  * [vagrant-berkshelf](https://github.com/berkshelf/vagrant-berkshelf)
  * [vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus)

It will start the Vagrant box from the `spec/integration` directory and
provision it.

#### RuboCop

Running RuboCop:

```bash
bundle exec rake rubocop
```
