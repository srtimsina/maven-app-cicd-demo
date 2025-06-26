pipeline {
    agent any
   environment {
    REPO_NAME = 'suryaraj/simplejavaapp'
   }
    stages {
        stage('Compile code') {
            steps {
                echo 'Packaging the app'
                sh 'mvn clean package'
            }
            post {
                success {
                    echo 'Now Archiving it...'
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }

        stage('Build docker image') {
            steps {
                echo 'Building docker image'
                sh 'whoami'
                sh 'docker image build -t $REPO_NAME:$BUILD_NUMBER .'
            }
        }
        stage('Scan docker image') {
            steps {
                echo 'Scaning docker image'
                sh 'trivy image $REPO_NAME:$BUILD_NUMBER'
            }
        }
        stage('Push image to registry') {
            steps {
                echo 'Pushing images'
                withDockerRegistry([credentialsId: 'dockerhubcredentials', url: '']) {
                    sh '''
                    docker push $REPO_NAME:$BUILD_NUMBER
                    '''
                }
            }
        }
    }
}
