pipeline {
    agent any

    environment {
        DOCKERHUB_CREDS = 'dockerhub-creds'
        DEV_IMAGE  = 'hemanth10bh1010/myapp-dev'
        PROD_IMAGE = 'hemanth10bh1010/myapp-prod'
    }

    stages {

        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Verify Branch') {
            steps {
                echo "Branch Name: ${env.BRANCH_NAME}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh "docker build -t ${DEV_IMAGE}:${BUILD_NUMBER} -t ${DEV_IMAGE}:latest ."
                    } else if (env.BRANCH_NAME == 'master') {
                        sh "docker build -t ${PROD_IMAGE}:${BUILD_NUMBER} -t ${PROD_IMAGE}:latest ."
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDS) {
                        if (env.BRANCH_NAME == 'dev') {
                            sh "docker push ${DEV_IMAGE}:${BUILD_NUMBER}"
                            sh "docker push ${DEV_IMAGE}:latest"
                        } else if (env.BRANCH_NAME == 'master') {
                            sh "docker push ${PROD_IMAGE}:${BUILD_NUMBER}"
                            sh "docker push ${PROD_IMAGE}:latest"
                        }
                    }
                }
            }
        }

        stage('Deploy Application') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh '''
                        docker rm -f myapp-dev-container || true
                        docker run -d -p 3000:3000 --name myapp-dev-container hemanth10bh1010/myapp-dev:latest
                        '''
                    } else if (env.BRANCH_NAME == 'master') {
                        sh '''
                        docker rm -f myapp-prod-container || true
                        docker run -d -p 3001:3000 --name myapp-prod-container hemanth10bh1010/myapp-prod:latest
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Build SUCCESS"
        }
        failure {
            echo "Build FAILED"
        }
    }
}
