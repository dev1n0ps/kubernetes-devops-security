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
              archive 'target/*.jar'
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

      stage('SonarQube - SAST') {
            steps {
               withSonarQubeEnv('SonarQube') {
                  sh "mvn sonar:sonar -Dsonar.projectKey=numeric-application -Dsonar.host.url=http://devsecops-demo.germanywestcentral.cloudapp.azure.com:9000"
               }
               timeout(time: 2, unit: 'MINUTES') { // Just in case something goes wrong, pipeline will be killed after a timeout
                  script {
                    waitForQualityGate abortPipeline: true
                  }
               }
            }
        }  

      	stage('Vulnerability Scan - Docker') {
          steps {
           sh "mvn dependency-check:check" 
/*            parallel(
        	    "Dependency Scan": {
        		    sh "mvn dependency-check:check"
			        },
 			        "Trivy Scan":{
				        sh "bash trivy-docker-image-scan.sh"
			        },
			        "OPA Conftest":{
				        sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-docker-security.rego Dockerfile'
			        }    	
      	    )*/
          }
          post {
            always {
                dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
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
               sh "sed -i 's#replace#dev1n0ps/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
               sh "kubectl apply -f k8s_deployment_service.yaml"
             }
           },
          // "Rollout Status": {
           //  withKubeConfig([credentialsId: 'kubeconfig']) {
               //sh "bash k8s-deployment-rollout-status.sh"
             //  sh "sed -i 's#replace#dev1n0ps/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
              // sh "kubectl apply -f k8s_deployment_service.yaml"
             //}
           //}
         )
       }
     }   
    }
}