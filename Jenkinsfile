pipeline {
	agent any
  stages {
    stage('Build') {
      steps {
	sh 'whoami'
	sh 'gem install bundler -v 2.1.4'
	sh 'gem install minitest'
      }
    }
    stage('Testing') {
      steps {
        sh 'ruby test tests/'
      }
    }
    stage('Deploy') {
      steps {
        echo 'Code is ready to deploy'
      }   
    }
  }
}
