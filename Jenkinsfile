pipeline {
    agent any

   environment {
    dockerImage = "suryaraj/javaapp"
   }
    stages {
        stage('Building Java App') {
            agent {
                label 'ubuntu-slave-node'
                }
            steps {
                sh 'mvn -f pom.xml clean package'
            }
            post{
                success {
                    echo "Build completed, now archiving the artifacts"
                    archiveArtifacts artifacts: '**/*.war', followSymlinks: false
                }
            }
        }
        stage('Create Docker image'){
            agent {
              label 'ubuntu-slave-node'
           }
            steps{
              copyArtifacts filter: '**/*.war', fingerprintArtifacts: true, projectName: env.JOB_NAME, selector: specific(env.BUILD_NUMBER)
              echo "creating docker image"
              sh 'whoami'
              sh 'docker build -t $dockerImage:$BUILD_NUMBER .'
            }
        }
        stage('Push Image'){
          agent {
            label 'ubuntu-slave-node'
          }
            steps {
                withDockerRegistry([credentialsId: 'dockerhubcredentials', url: '']) {
                    sh '''
                    docker push $dockerImage:$BUILD_NUMBER
                    '''
                }
            }
        }
        stage('Deploy to Development Env') {
            agent {
                label 'ubuntu-slave-node'
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
        stage('Deploytoprod') {
            steps {
                echo 'Deploying to production env.'
            }
        }
    }
}