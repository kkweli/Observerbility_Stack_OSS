#!/bin/bash

# Configuration
LOCAL_REGISTRY="localhost:5000"
IMAGES=(
  "grafana/grafana:latest"
  "prom/prometheus:latest"
  "prom/node-exporter:latest"
)

# Function to get image digest
get_image_digest() {
    local image_name="$1"
    if ! digest=$(docker image inspect "$image_name" --format='{{.Id}}' 2>/dev/null); then
        return 1
    fi
    echo "$digest"
}

# Check and update images as needed
for IMAGE in "${IMAGES[@]}"; do
    # Extract image name for local registry
    IMAGE_NAME=$(echo "$IMAGE" | cut -d'/' -f2)
    LOCAL_IMAGE="${LOCAL_REGISTRY}/${IMAGE_NAME}"
    
    echo "Checking ${IMAGE_NAME}..."
    
    # Pull latest from Docker Hub to compare
    docker pull "$IMAGE"
  
    # Get digests for comparison
    HUB_DIGEST=$(get_image_digest "$IMAGE")
    LOCAL_DIGEST=$(get_image_digest "$LOCAL_IMAGE")
    
    if [ "$LOCAL_DIGEST" != "$HUB_DIGEST" ]; then
        echo "Update needed for $IMAGE_NAME"
        
        echo "Tagging $IMAGE as $LOCAL_IMAGE..."
        docker tag "$IMAGE" "$LOCAL_IMAGE"
        
        echo "Pushing $LOCAL_IMAGE to local registry..."
        docker push "$LOCAL_IMAGE"
    else
        echo "$IMAGE_NAME is up to date in local registry"
    fi
done

echo "Local registry check complete."