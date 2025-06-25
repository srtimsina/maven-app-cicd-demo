pipeline {
    agent any

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
                sh 'docker image build -t mylocalrepo/simplejavaapp:$BUILD_NUMBER .'
            }
        }
        stage('Scan docker image') {
            steps {
                echo 'Scaning docker image'
            }
        }
        stage('Push image to registry') {
            steps {
                echo 'Pushing images'
            }
        }
    }
}
