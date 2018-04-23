node('jenkins-slave') {
	try {
		def mvnHome = tool 'maven3'
		def project_name = "total/atlas-app"
		echo 'debut ...'
		stage('Checkout') {
			checkout scm
		}

		stage('Build') {
			sh "${mvnHome}/bin/mvn clean install -DskipTests"
		}

		//stage('Unit Test') {
		//	sh "${mvnHome}/bin/mvn test"
		//}

		//stage('SonarQube analysis') {
		//	withSonarQubeEnv('sonar') {
		//		sh "${mvnHome}/bin/mvn sonar:sonar"
		//	}
		//}

		//stage('Quality Gate'){
		//	timeout(time: 30, unit: 'MINUTES') {
		//		def qg = waitForQualityGate()
		//		if (qg.status != 'OK') {
		//			error "Pipeline aborted due to quality gate failure: ${qg.status}"
		//		}
		//	}
		//}

		stage('Build Docker Image') {
			app = docker.build("${project_name}:${env.BRANCH_NAME}")
		}

		//stage('Test image') {
		//	/* Ideally, we would run a test framework against our image.
		//	 * For this example, we're using a Volkswagen-type approach ;-) 
		//	 */
		//	app.inside {
		//		sh 'echo "Tests passed"'
		//	}
		//}

		stage('deploy APP') {
			sh("kubectl apply -f atlas_app_deploy.yaml")
			sh("kubectl apply -f atlas_app_service.yaml")
			sh("kubectl apply -f atlas_app_ingress.yaml")
		}
	} catch (e) {
       		// If there was an exception thrown, the build failed
	    	currentBuild.result = "FAILED"
        	throw e
   	} finally {
     		// Success or failure, always send notifications
	    	notifyBuild(currentBuild.result)
   	}
}

def notifyBuild(String buildStatus = 'STARTED') {
	
	// build status of null means successful
   	buildStatus =  buildStatus ?: 'SUCCESSFUL'
 	   	
	def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
   	def details = """<p>STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
     		<p>Check console output at "<a href="${env.BUILD_URL}">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>"</p>"""
   	def mailRecipients = "amine9@gmail.com"
   	
	def myProviders ; //= [ [$class: 'CulpritsRecipientProvider'], [$class: 'DevelopersRecipientProvider'] ];

	if (buildStatus == 'SUCCESSFUL') {
     		echo 'amine1'
		myProviders = [ [$class: 'CulpritsRecipientProvider'] ];
   	} else {
     		echo 'amine2'
		myProviders = [ [$class: 'DevelopersRecipientProvider'] ];
   	}
	myProviders = [ [$class: 'ListRecipientProvider'] ];
	emailext (
           subject: subject,
           body: details,
           to: "${mailRecipients}",
	   //replyTo: "${mailRecipients}"
           recipientProviders: myProviders
     	)
}

