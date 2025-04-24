pipeline {
    agent any

    stages {
        stage('BUILD') {
            steps {
                echo 'Buidling the code'
            }
        }
        stage('UNITTEST') {
            steps {
                echo 'Running the unititest'
            }
        }
        stage('DeploytoDevenv') {
            steps {
                echo 'Deploing to deve env'
            }
        }
        stage('Deploytoprod') {
            steps {
                echo 'Deploying to production env.'
            }
        }
    }
}