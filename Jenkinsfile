pipeline {
    agent any
    environment {
        KUBECONFIG = '/var/jenkins_home/.kube/config'
        OCI_CREDENTIALS = 'oci-credentials'
        OKE_CLUSTER_NAME = 'DevOps_Cluster'
        OKE_COMPARTMENT_NAME = 'OKE'
    }
    stages {
        stage('Checkout') {
            steps {
                withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
                    git url: 'https://github.com/AhmedFatir/k8s-inception', branch: 'main', credentialsId: 'github-token'
                }
            }
        }
        stage('Apply K8s Manifests') {
            steps {
                sh 'kubectl apply -Rf k8s/'
            }
        }
        stage('Verify Deployment') {
            steps {
                sh 'kubectl get pods -A && kubectl get svc -A'
            }
        }
    }
    post {
        always {
            echo "Pipeline finished"
        }
        failure {
            echo "Pipeline failed"
        }
        success {
            echo "Pipeline succeeded"
        }
    }
}