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
        stage('Unit test') {
            steps {
                echo 'We are running unittest'
            }
        }
        stage('Run Security scan') {
            steps {
                echo 'Security testing is running'
            }
        }
        stage('Build docker image') {
            steps {
                echo 'Creating docker image'
            }
        }
        stage('Push image to registry') {
            steps {
                echo 'Pushing images'
            }
        }
    }
}
