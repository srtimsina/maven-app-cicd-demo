pipeline{
    agent {
        label 'JenkinsSlave'
    }
    environment {
        dockerImage = "pradipchaudhary7/jenkinspipelinesetup"
    }
    stages{
        stage('Build Java App'){
            agent {
              label 'JenkinsSlave'
            }
            steps{
            sh 'mvn -f pom.xml clean package'
            }
            post{
                success {
                echo "Build completed, so archiving the war file"
                archiveArtifacts artifacts: '**/*.war', followSymlinks: false
                }
            }
        }
        stage('Create Docker image'){
            agent {
              label 'JenkinsSlave'
           }
            steps{
              copyArtifacts filter: '**/*.war', fingerprintArtifacts: true, projectName: env.JOB_NAME, selector: specific(env.BUILD_NUMBER)
              echo "creating docker image"
              sh 'docker build -t $dockerImage:$BUILD_NUMBER .'
            }
        }
        stage('Trivy Scan for Docker Image') {
            steps {
                echo "Scanning docker images... phase"
            }
        }
        stage('Push Image'){
          agent {
            label 'JenkinsSlave'
          }
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-credentials', url: '']) {
                    sh '''
                    docker push $dockerImage:$BUILD_NUMBER
                    '''
                }
            }
        }
        stage('Deploy to Development Env') {
            agent {
                label 'JenkinsSlave'
            }
            steps {
                echo "Running app on development env"
                sh '''
                docker stop tomcatInstanceDev || true
                docker rm tomcatInstanceDev || true
                docker run -itd --name tomcatInstanceDev -p 8082:8080 $dockerImage:$BUILD_NUMBER 
                sh '''
            }
        }
        stage('Deploy Production Environment') {
            agent {
                label 'JenkinsSlave'
            }
            steps {
                timeout(time:1, unit:'DAYS'){
                input message:'Approve PRODUCTION Deployment?'
                }
                echo "Running app on Prod env"
                sh '''
                docker stop tomcatInstanceProd || true
                docker rm tomcatInstanceProd || true
                docker run -itd --name tomcatInstanceProd -p 8083:8080 $dockerImage:$BUILD_NUMBER
                '''
            }
        }
    }
}