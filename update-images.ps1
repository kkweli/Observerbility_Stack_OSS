# PowerShell script to intelligently update local registry
$LOCAL_REGISTRY = "localhost:5000"
$IMAGES = @(
  "grafana/grafana:latest",
  "prom/prometheus:latest",
  "prom/node-exporter:latest"
)

function Get-ImageDigest {
    param (
        [string]$ImageName
    )
    try {
        $digest = docker image inspect $ImageName --format='{{.Id}}'
        return $digest
    } catch {
        return $null
    }
}

foreach ($IMAGE in $IMAGES) {
    $IMAGE_NAME = $IMAGE.Split("/")[-1]
    $LOCAL_IMAGE = "$LOCAL_REGISTRY/$IMAGE_NAME"
    
    Write-Host "Checking $IMAGE_NAME..."
    
    # Pull latest from Docker Hub to compare
    docker pull $IMAGE
    $hubDigest = Get-ImageDigest $IMAGE
    $localDigest = Get-ImageDigest $LOCAL_IMAGE
    if ($localDigest -ne $hubDigest) {
        Write-Host "Update needed for $IMAGE_NAME"
        
        Write-Host "Tagging $IMAGE as $LOCAL_IMAGE..."
        docker tag $IMAGE $LOCAL_IMAGE
        
        Write-Host "Pushing $LOCAL_IMAGE to local registry..."
        docker push $LOCAL_IMAGE
    } else {
        Write-Host "$IMAGE_NAME is up to date in local registry"
    }
}

Write-Host "Local registry check complete."
