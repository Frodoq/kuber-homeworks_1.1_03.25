#!/bin/bash

# Функция для генерации манифестов из шаблонов
generate_manifests() {
    local namespace=$1
    local app_name=$2
    local image_tag=$3
    local replica_count=$4
    
    echo "Generating manifests for $app_name in namespace $namespace..."
    
    # Генерируем deployment
    cat myapp/templates/deployment.yaml | \
        sed "s/APP_NAME/$app_name/g" | \
        sed "s/NAMESPACE/$namespace/g" | \
        sed "s/REPLICA_COUNT/$replica_count/g" | \
        sed "s/IMAGE_TAG/$image_tag/g" > manifests/$namespace-$app_name-deployment.yaml
    
    # Генерируем service
    cat myapp/templates/service.yaml | \
        sed "s/APP_NAME/$app_name/g" | \
        sed "s/NAMESPACE/$namespace/g" | \
        sed "s/IMAGE_TAG/$image_tag/g" > manifests/$namespace-$app_name-service.yaml
    
    echo "Generated manifests:"
    echo "  - manifests/$namespace-$app_name-deployment.yaml"
    echo "  - manifests/$namespace-$app_name-service.yaml"
}

# Функция деплоя приложения
deploy_app() {
    local namespace=$1
    local app_name=$2
    local image_tag=$3
    local replica_count=$4
    
    echo "Deploying $app_name to namespace $namespace with image nginx:$image_tag..."
    
    # Создаем namespace если не существует
    kubectl create namespace $namespace --dry-run=client -o yaml | kubectl apply -f -
    
    # Генерируем манифесты
    generate_manifests $namespace $app_name $image_tag $replica_count
    
    # Применяем манифесты
    kubectl apply -f manifests/$namespace-$app_name-deployment.yaml
    if [ $? -eq 0 ]; then
        echo "✅ Deployment applied successfully"
    else
        echo "❌ Failed to apply deployment"
        return 1
    fi
    
    kubectl apply -f manifests/$namespace-$app_name-service.yaml
    if [ $? -eq 0 ]; then
        echo "✅ Service applied successfully"
    else
        echo "❌ Failed to apply service"
        return 1
    fi
    
    echo "✅ Successfully deployed $app_name in namespace $namespace"
    return 0
}

# Очищаем предыдущие манифесты
rm -rf manifests
mkdir -p manifests

echo "Starting deployment of multiple application versions..."
echo "======================================================"

# Версия 1 в namespace app1
deploy_app "app1" "myapp-v1" "1.25" "1"

# Версия 2 в том же namespace app1
deploy_app "app1" "myapp-v2" "1.26" "1"

# Версия 3 в namespace app2
deploy_app "app2" "myapp-v3" "1.27" "2"

echo ""
echo "🎉 Deployment process completed!"
echo ""
