pipeline {
    agent any
    environment {
        dockerImage = "suryaraj/devops-midday"
    }
stages {
        stage('Build') {
            steps { 
                sh 'mvn package -f pom.xml'
            }
            post {
                success {
                    echo 'Now Archiving it...'
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }
        stage('Create Tomcat Image') {
            steps { 
                copyArtifacts filter: '**/*.war', fingerprintArtifacts: true, projectName: env.JOB_NAME, selector: specific(env.BUILD_NUMBER)
                sh 'docker image build -t $dockerImage:$BUILD_NUMBER .'
            }
        }

        stage('Trivy Scan for Docker Image') {
            steps {
                sh 'echo '
                sh 'trivy image --timeout 10m --scanners vuln --exit-code 1 --severity HIGH,CRITICAL --ignore-unfixed $dockerImage:$BUILD_NUMBER'
            }
        }

        stage('Push Scanned Image to DockerHub') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-credentials', url: '']) {
                    sh '''
                    docker push $dockerImage:$BUILD_NUMBER
                    '''
                }
            }
        }

        stage('Deploy to staging') {
            steps { 
                sh 'docker run -itd --name tomcatInstanceStaging -p 8082:8080 $dockerImage:$BUILD_NUMBER'
            }
        }
    }
}