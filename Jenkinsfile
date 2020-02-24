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
        sh 'ruby tests/attendent_test.rb'
	sh 'ruby tests/coordinator_test.rb'
	sh 'ruby tests/owner_test.rb'
	sh 'ruby tests/parking_lot_test.rb'
	sh 'ruby tests/parking_space_test.rb'
      }
    }
    stage('Deploy') {
      steps {
        echo 'Code is ready to deploy'
      }   
    }
  }
}
