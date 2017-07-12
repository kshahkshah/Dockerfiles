.PHONY: build run kill enter push pull

build:
	docker build --rm -t devise-ftp-server .

run: kill
	docker run -d --name ftpd_server -p 21:21 -p 30000-30009:30000-30009 devise-ftp-server

kill:
	-docker kill ftpd_server
	-docker rm ftpd_server

enter:
	docker exec -it ftpd_server sh -c "export TERM=xterm && bash"

# git commands for quick chaining of make commands
push:
	git push --all
	git push --tags

pull:
	git pull
