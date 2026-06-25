pipeline {
    agent any
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
   
}
}