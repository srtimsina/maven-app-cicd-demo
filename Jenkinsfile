pipeline {
    agent any
   environment {
    REPO_NAME = 'suryaraj/simplejavaapp'
   }
    stages {
        stage('Compile code') {
            steps {
                echo 'Packaging the app'
                sh 'mvn clean compile'
            }
        }
        stage('Unit Test') {
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
}
