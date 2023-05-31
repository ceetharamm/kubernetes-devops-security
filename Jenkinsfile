pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' //so that they can be downloaded later
            }
        }
    
      stage('Unit tests') {
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
    
        stage('Docker Build and Push') {
            steps {
              withDockerRegistry([credentialsId: "docker-hub", url: ""]){
                sh 'printenv'
                sh 'docker build -t ceetharamm/numeric-app:""$GIT_COMMIT"" .'
                sh 'docker push ceetharamm/numeric-app:""$GIT_COMMIT""'
              }
            }
        }
    
        stage('Kuberneted Deployment - Dev') {
            steps {
              withDKubeConfig([credentialsId: "kubeconfig"]){
                sh "sed -i 's#replace#ceetharamm/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
                sh "kubectl apply -f k8s_deployment_service.yaml"
              }
            }
        }
    
    
    }
}
