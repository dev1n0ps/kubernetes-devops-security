pipeline {
  agent any

  tools {
    maven 'Maven 3.9.9'
  }

  stages {
      stage('Build Artifact') {
            steps {
              sh "echo $PATH"
              sh "java -version"
              sh "mvn -v"
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' //so that they can be downloaded later
            }
        }  

      stage('Unit Tests') {
            steps {
              sh "mvn test"
            }
        }    
    }
}