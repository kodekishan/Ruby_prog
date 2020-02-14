pipeline {
	agent { docker { image 'ruby' } }
  stages {
    stage('requirements') {
      steps {
				sh 'whoami'
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
        sh 'gem install minitest'
      }   
    }
  }
}
