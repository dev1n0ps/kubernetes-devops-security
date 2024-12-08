pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true -Djava.security.manager=allow"
              archive 'target/*.jar' //so that they can be downloaded later
            }
        }   
    }
}