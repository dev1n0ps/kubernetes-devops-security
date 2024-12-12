pipeline {
    agent any

    environment {
        deploymentName = "devsecops"
        containerName = "devsecops-container"
        serviceName = "devsecops-svc"
        imageName = "dev1n0ps/numeric-app:${env.VERSION}"
        applicationURL="http://devsecops-demo.germanywestcentral.cloudapp.azure.com"
        applicationURI="/increment/99"
    }

    tools {
        maven 'Maven 3.9.9'
    }

    stages {
        stage('increment version') {
            steps {
                script {
                    echo 'incrementing app version'
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                            versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.VERSION = "$version-$BUILD_NUMBER"
                    echo "App Version: ${env.VERSION}"
                }
            }
        }

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
            post {
                always {
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
                timeout(time: 2, unit: 'MINUTES') {
                    // Just in case something goes wrong, pipeline will be killed after a timeout
                    script {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }

        stage('Vulnerability Scan - Docker') {
            steps {

                parallel(
                        "Dependency Scan": {
                            sh "mvn dependency-check:check"
                        },
                        "Trivy Scan": {
                            sh "bash trivy-docker-image-scan.sh"
                        },
                        "OPA Conftest": {
                            sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-docker-security.rego Dockerfile'
                        }
                )
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
                    sh 'sudo docker build -t dev1n0ps/numeric-app:${VERSION} .'
                    sh 'docker push dev1n0ps/numeric-app:${VERSION}'
                }
            }
        }

        stage('Vulnerability Scan - Kubernetes') {
            steps {
                parallel(
                        "OPA Scan": {
                            sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-k8s-security.rego k8s_deployment_service.yaml'
                        },
                        "Kubesec Scan": {
                            sh "bash kubesec-scan.sh"
                        },
                        "Trivy Scan": {
                            sh "bash trivy-k8s-scan.sh"
                        }
                )
            }
        }


        stage('K8S Deployment - DEV') {
            environment {
                // Dynamically set imageName for the deployment script
                imageName = "dev1n0ps/numeric-app:${env.VERSION}"
            }
            steps {
                parallel(
                        "Deployment": {
                            withKubeConfig([credentialsId: 'kubeconfig']) {
                                sh '''
                                    echo "Deploying using image: ${imageName}"
                                    export IMAGE_NAME=${imageName}
                                    bash k8s-deployment.sh
                                '''
                            }
                        },
                        "Rollout Status": {
                            withKubeConfig([credentialsId: 'kubeconfig']) {
                                sh "bash k8s-deployment-rollout-status.sh"
                            }
                        }
                )
            }
        }
    }
}

