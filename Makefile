version=0.2

default: build

build:
	cd files; tar -cf ../files.tar --owner=0 --group=0 *
	docker build -t henne90gen/alpine-apache2-webdav:$(version) .
	rm files.tar

push:
	docker push henne90gen/alpine-apache2-webdav:$(version)

run: build
	cd test; docker-compose up -d
