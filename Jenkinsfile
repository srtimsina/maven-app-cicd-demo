pipeline {
    agent any
   environment {
    REPO_NAME = 'suryaraj/simplejavaapp'
   }
    stages {
        stage('Compile code') {
            agent {
                label 'ubuntu-slave'
            }
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
            agent{
                label 'built-innode'
            }
            steps {
                echo 'Building docker image'
                sh 'whoami'
                sh 'docker image build -t $REPO_NAME:$BUILD_NUMBER .'
            }
        }
        stage('Scan docker image') {
            agent {
                label 'built-innode'
            }
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
        stage('Deploy to devenv') {
            steps{
                echo "Deploying to dev env"
                sh '''
                #docker container stop mysimeapp || true
                #docker container rm mysimeapp || true
                docker run -d --name mysimeapp -p 8082:8080 $REPO_NAME:$BUILD_NUMBER
                '''
            }
        }
        stage('Deploy to Staging') {
            steps{
                timeout(time:5, unit:'MINUTES'){
                input message:'Approve PRODUCTION Deployment?'
                }
                echo "Deploying to Staging env"
                sh '''
                docker container stop mysimeapp-staging || true
                docker container rm mysimeapp-staging || true
                docker run -d --name mysimeapp-staging -p 8083:8080 $REPO_NAME:$BUILD_NUMBER
                '''
            }
        }
    }
post { 
        always { 
            mail to: 'devopsuryaraj@gmail.com',
            subject: "Job '${JOB_NAME}' (${BUILD_NUMBER}) status",
            body: "Please go to ${BUILD_URL} and verify the build"
        }
        success { 
            mail bcc: '', body: """Hi Team,
            Build #$BUILD_NUMBER is successful, please go through the url
            $BUILD_URL
            and verify the details.
            Regards,
            DevOps Team""", cc: '', from: '', replyTo: '', subject: 'BUILD SUCCESS NOTIFICATION', to: 'devopsuryaraj@gmail.com'
        }
        failure { 
            mail bcc: '', body: """Hi Team,
            Build #$BUILD_NUMBER is unsuccessful, please go through the url
            $BUILD_URL
            and verify the details.
            Regards,
            DevOps Team""", cc: '', from: '', replyTo: '', subject: 'BUILD FAILED NOTIFICATION', to: 'devopsuryaraj@gmail.com'
        }
    }
}
