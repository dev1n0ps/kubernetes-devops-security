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
            post{
                always{
                  junit 'target/surefire-reports/*.xml'
                  jacoco execPattern: 'target/jacoco.exec'
                }
            }
        }

      stage('Docker Build and Push') {
         steps {
           withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
             sh 'printenv'
             sh 'docker build -t dev1n0ps/numeric-app:""$GIT_COMMIT"" .'
             sh 'docker push dev1n0ps/numeric-app:""$GIT_COMMIT""'
           }
         }
       } 

      stage('K8S Deployment - DEV') {
       steps {
         parallel(
           "Deployment": {
             withKubeConfig([credentialsId: 'kubeconfig']) {
               sh "bash k8s-deployment.sh"
             }
           },
           "Rollout Status": {
             withKubeConfig([credentialsId: 'kubeconfig']) {
               //sh "bash k8s-deployment-rollout-status.sh"
               sh "sed -i 's#replace#dev1n0ps/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
               sh "kubectl apply -f k8s_deployment_service.yaml"
             }
           }
         )
       }
     }   
    }
}