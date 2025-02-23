pipeline {
    agent any
    environment {
        KUBECONFIG = '/var/jenkins_home/.kube/config'
        OCI_CREDENTIALS = 'oci-credentials' // ID of your OCI credentials in Jenkins
        OKE_CLUSTER_NAME = 'DevOps_Cluster'
        OKE_COMPARTMENT_NAME = 'OKE'
    }
    triggers {
        githubPush()
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/AhmedFatir/k8s-inception', branch: 'main'
            }
        }
        stage('Deploy to OKE') {
            steps {
                withCredentials([string(credentialsId: OCI_CREDENTIALS, variable: 'OCI_CREDENTIALS')]) {
                    try {
                        sh '''
                          echo "Deploying to OKE Cluster: ${OKE_CLUSTER_NAME} in Compartment: ${OKE_COMPARTMENT_NAME}"
                          kubectl apply -f k8s_manifests/
                        '''
                    } catch (Exception e) {
                        echo "Deployment failed: ${e.getMessage()}"
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
                }
            }
        }
        stage('Verify Deployment') {
            steps {
                try {
                    sh 'kubectl get pods -A && kubectl get svc -A'
                } catch (Exception e) {
                    echo "Verification failed: ${e.getMessage()}"
                    currentBuild.result = 'FAILURE'
                    throw e
                }
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