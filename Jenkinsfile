pipeline {
  agent any
  stages {
    stage('read json') {
      steps {
        script {
          sh 'curl -o date.json "http://date.jsontest.com"'
          json = readJSON file: 'date.json'
          echo "Today is ${json.date}"
        }
      }
    }
  }
  post {
    always {
      sh 'echo finished!'
    }
  }
}
