pipeline {
    agent any
    environment {
        KUBECONFIG = credentials('kubeconfig')
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'github-token', url: 'https://github.com/AhmedFatir/k8s-inception'
            }
        }
        stage('Set up Kubernetes Context') {
            steps {
                sh '''
                echo "$KUBECONFIG" > /tmp/kubeconfig
                export KUBECONFIG=/tmp/kubeconfig
                if ! kubectl cluster-info; then
                    echo "ERROR: Kubernetes cluster is not reachable."
                    exit 1
                fi
                '''
            }
        }
        stage('Apply K8s Manifests') {
            steps {
                sh '''
                export KUBECONFIG=/tmp/kubeconfig
                kubectl apply -Rf k8s/
                '''
            }
        }
        stage('Verify Deployment') {
            steps {
                sh '''
                export KUBECONFIG=/tmp/kubeconfig
                kubectl get pods -A
                kubectl get svc -A
                '''
            }
        }
    }
}
