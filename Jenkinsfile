pipeline {
  agent { docker { image 'ruby:2.6.3' } }
  stages {
    stage('requirements') {
      steps {
        sh 'gem install bundler -v 2.1.4'
	sh 'gem install minitest'
      }
    }
    stage('build') {
      steps {
        sh 'bundle install'
      }
    }
    stage('test') {
      steps {
        sh 'minitest'
      }   
    }
  }
}
