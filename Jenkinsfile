pipeline {
    agent {
        label 'ubuntu-slave'
    }
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
                sh 'mvn clean compile'
            }
            post {
                success {
                    echo 'Now Archiving it...'
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }
        stage('Unit Test') {
            agent {
                label 'ubuntu-slave'
            }
            steps {
                echo 'Running Unit Tests'
                sh 'mvn test'
            }
        }
        stage('Checkstyle Analysis') {
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
        }
        stage('SonarQube Analysis'){
            agent {
                label 'ubuntu-slave'
            }
            steps {
                withSonarQubeEnv('local-sonarqube') {
                    sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=java-tomcat-sample \
                        -Dsonar.projectName=java-tomcat-sample \
                        -Dsonar.projectVersion=4.0 \
                        -Dsonar.sources=jenkins/java-tomcat-sample/src/ \
                        -Dsonar.junit.reportsPath=target/surefire-reports/ \
                        -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                        -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                }

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
