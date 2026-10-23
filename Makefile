deploy-dev:
	kubectl apply -k k8s/overlays/dev

deploy-prod:
	kubectl apply -k k8s/overlays/prod

scan:
	trivy image --severity HIGH,CRITICAL store-api:1.1

diff:
	kubectl diff -k k8s/overlays/prod

destroy:
	kubectl delete -k k8s/overlays/prod
	kubectl delete -k k8s/overlays/dev
