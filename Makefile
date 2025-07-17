.PHONY: run logs stop run-nofe logs-nofe stop-nofe clear db

run:
	docker compose -f ./docker-compose/dev-no-services.yml up -d

logs:
	docker compose -f ./docker-compose/dev-no-services.yml logs -f --tail=100

stop:
	docker compose -f ./docker-compose/dev-no-services.yml down

run-nofe:
	docker compose -f ./docker-compose/dev-no-services-external-frontend.yml up -d

logs-nofe:
	docker compose -f ./docker-compose/dev-no-services-external-frontend.yml logs -f --tail=100

stop-nofe:
	docker compose -f ./docker-compose/dev-no-services-external-frontend.yml down

clear:
	rm -rf ./docker-compose/services/blockscout-db-data && rm -rf ./docker-compose/services/logs && rm -rf ./docker-compose/services/redis-data && rm -rf ./docker-compose/services/stats-db-data && rm -f ./docker-compose/services/dets/*

db:
	docker exec -it db  psql -d blockscout -U blockscout