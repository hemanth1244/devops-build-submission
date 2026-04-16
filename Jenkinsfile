pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub-creds'
        DEV_IMAGE  = 'hemanth10bh1010/myapp-dev'
        PROD_IMAGE = 'hemanth10bh1010/myapp-prod'
        APP_NAME   = 'myapp'
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
                script {
                    echo "Branch Name: ${env.BRANCH_NAME}"
                    sh 'git branch'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh "docker build -t ${DEV_IMAGE}:${BUILD_NUMBER} -t ${DEV_IMAGE}:latest ."
                    } else if (env.BRANCH_NAME == 'master') {
                        sh "docker build -t ${PROD_IMAGE}:${BUILD_NUMBER} -t ${PROD_IMAGE}:latest ."
                    } else {
                        error("This pipeline supports only dev and master branches")
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        if (env.BRANCH_NAME == 'dev') {
                            sh "docker push ${DEV_IMAGE}:${BUILD_NUMBER}"
                            sh "docker push ${DEV_IMAGE}:latest"
                        } else if (env.BRANCH_NAME == 'main') {
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
                        docker run -d --name myapp-dev-container -p 3000:3000 yourdockerhubusername/myapp-dev:latest
                        '''
                    } else if (env.BRANCH_NAME == 'main') {
                        sh '''
                        docker rm -f myapp-prod-container || true
                        docker run -d --name myapp-prod-container -p 3000:3000 yourdockerhubusername/myapp-prod:latest
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}
