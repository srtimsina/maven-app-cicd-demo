pipeline {
    agent any
    stages {
        stage('Compile code') {
            steps {
                echo 'Compiling the app'
                sh 'mvn -f pom.xml install -DskipTests'
            }
            post {
                success {
                    echo 'Now Archiving it...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }
}
}
