pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "java -version"
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' //so that they can be downloaded later
            }
        }   
    }
}