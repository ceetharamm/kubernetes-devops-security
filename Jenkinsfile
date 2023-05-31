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
    
        stage('Mutation Tests - PIT') {
          steps {
            sh "mvn org.pitest:pitest-maven:mutationCoverage"
          }
          post {
            always {
              pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
            }
          }
        }
    
        stage('SonarQube - SAST') {
            steps {
              sh "mvn clean verify sonar:sonar -Dsonar.projectKey=numeric-application -Dsonar.projectName='numeric-application' -Dsonar.host.url=http://devsecops-yoms.eastus.cloudapp.azure.com:9000   -Dsonar.token=sqp_cef539346a53068c6bcabdf875c5dfd07ba31ce9"
            }
        }
    
        stage('Kuberneted Deployment - Dev') {
            steps {
              withKubeConfig([credentialsId: "kubeconfig"]){
                sh "sed -i 's#replace#ceetharamm/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
                sh "kubectl apply -f k8s_deployment_service.yaml"
              }
            }
        }
    
    
    }
}
