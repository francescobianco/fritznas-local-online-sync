
-include .env
export $(shell test -f .env && cut -d= -f1 .env)

build:
	@echo "Building..."
	@chmod +x sync.sh docker-entrypoint.sh
	@docker build -t javanile/fritznas-local-online-sync .

kill:
	@docker kill $(shell docker ps | grep fritznas | head -c 12)

test: build
	docker run --rm -it javanile/fritznas-local-online-sync

test-cron: build
	docker run --rm -it -e "CRON_SCHEDULE=* * * * *" javanile/fritznas-local-online-sync

test-sync: build
	docker run --rm -it \
	 	--device /dev/fuse \
		--cap-add SYS_ADMIN \
		--security-opt apparmor:unconfined \
		-e "FTP_HOST=$${FTP_HOST}" \
		-e "FTP_PORT=$${FTP_PORT}" \
		-e "FTP_USER=$${FTP_USER}" \
		-e "FTP_PASSWORD=$${FTP_PASSWORD}" \
		javanile/fritznas-local-online-sync
