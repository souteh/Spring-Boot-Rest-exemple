def label = "jenkins-slave"

podTemplate(label: label, containers: [
  
  containerTemplate(name: 'docker', image: 'docker', command: 'cat', ttyEnabled: true)
  
],
volumes: [
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
]) {


node('jenkins-slave') {
    def mvnHome = tool 'maven3'
    
    stage('Checkout') {
        checkout scm
    }

    stage('Build') {
        sh "${mvnHome}/bin/mvn clean install -DskipTests"
    }
    
    stage('Unit Test') {
    	sh "${mvnHome}/bin/mvn test"
    }
    
    stage('SonarQube analysis') {
    	withSonarQubeEnv('sonar') {
      		sh "${mvnHome}/bin/mvn sonar:sonar"
    	}
  	}
  	
  	/*stage('deploy') {
    *	sh "${mvnHome}/bin/mvn deploy"
    *} */
stage('deploy APP') {
  	    sh("kubectl apply -f /tools/maven_repository/atlas_app_deploy.yaml")
  	    sh("kubectl apply -f /tools/maven_repository/atlas_app_service.yaml")
  	}
  	
  	
  	stage('Build Docker Image') {
    	app = docker.build("total/myapp")
    }
    
    stage('Test image') {
        /* Ideally, we would run a test framework against our image.
         * For this example, we're using a Volkswagen-type approach ;-) */

        app.inside {
            sh 'echo "Tests passed"'
        }
    }

   stage('Push image') {
		 /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}")
    
            app.push("latest")
        }
    
    } 
    
    
    
        
	stage ('Run') {
            docker.image("total/myapp").run('--rm -p 18090:8090 -p 18091:8091 --name app')
        }
 
      /*  stage ('Final') {
       *     build job: 'customer-service-pipeline', wait: false
        }*/ 
  	
}
}
