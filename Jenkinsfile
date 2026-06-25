pipeline {
    agent any
    environment {
        scannerHome = tool 'sonarscanner8.1'
    }
stages{
        stage('Build') {
            steps {
                sh 'mvn -f pom.xml install -DskipTests'
            }
            post {
                success {
                    echo 'Now Archiving it...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }
        stage('UNIT TEST') {
            steps {
                sh 'mvn -f pom.xml test'
            }
        }
        stage('Checkstyle Analysis') {
            steps {
                sh 'mvn -f pom.xml checkstyle:checkstyle'
            }
        }
        stage('SonarQube Analysis'){
            steps {
                withSonarQubeEnv('sonarqubeserver') {
                    sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=java-tomcat-sample \
                        -Dsonar.projectName=java-tomcat-sample \
                        -Dsonar.projectVersion=4.0 \
                        -Dsonar.sources=src/ \
                        -Dsonar.junit.reportsPath=target/surefire-reports/ \
                        -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                        -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                }

            }
        }
   
}
}