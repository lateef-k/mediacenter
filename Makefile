.PHONY: update-all-images update-containers

# Target to update all images with 'latest' tag
update-all-latest-images:
	@echo "Pulling latest images..."
	@podman images --format "{{.Repository}}:{{.Tag}}" | grep ":latest" | xargs -I {} podman pull {}

update-all-images:
	@echo "Pulling latest images..."
	@podman images --format "{{.Repository}}:{{.Tag}}" |  xargs -I {} podman pull {}

# Target to restart containers using the 'latest' image
update-containers:
	@echo "Restarting containers using 'latest' images..."
	@for container in $$(podman ps --format "{{.ID}} {{.Image}}" | grep ":latest" | awk '{print $$1}'); do \
		image=$$(podman inspect --format "{{.Config.Image}}" $$container); \
		echo "Updating container with image $$image"; \
		podman stop $$container; \
		podman rm $$container; \
		podman run -d $$image; \
	done

# Combined target to update images and then restart containers
update: update-all-images update-containers
	@echo "Update complete!"

