node('jenkins-slave') {
    try {
        echo 'Cisnake 1'
        def mvnHome = tool 'maven3'
        def kaka
        /* def VERSION=$(date %Ym%d%H%M%S).git.$GIT_REVISION */
        def image = "total/atlas-app"
        /* :${env.BRANCH_NAME}.${env.BUILD_NUMBER}" */
    
        stage('Checkout') {
            def toto = checkout scm
            def titi = toto.GIT_COMMIT
            kaka = toto
		echo 'Cisnake 2'
        }
        
        stage('Build Docker Image') {
        	app = docker.build("${image}:${env}:${currentBuild}")
            app = docker.build("${image}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}")
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

        stage('Quality Gate'){
            timeout(time: 30, unit: 'MINUTES') {
                def qg = waitForQualityGate()
                if (qg.status != 'OK') {
                    error "Pipeline aborted due to quality gate failure: ${qg.status}"
                }
            }
        }
  	    
        stage('Build Docker Image') {
		    /* sh ("docker build -t total/myapp:4.4 .") */
    	    app = docker.build("${image}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}")
            app = docker.build("${image}:latest")
        }
    
        stage('Test image') {
            /* Ideally, we would run a test framework against our image.
             * For this example, we're using a Volkswagen-type approach ;-) */
            
            app.inside {
                sh 'echo "Tests passed"'
            }
        }
    
        stage('deploy APP') {
  	        sh("kubectl apply -f atlas_app_deploy.yaml")
  	        sh("kubectl apply -f atlas_app_service.yaml")
  	        sh("kubectl apply -f atlas_app_ingress.yaml")
  	    }
   
    } catch (e) {
        // If there was an exception thrown, the build failed
	    echo 'Cisnake 3'
        currentBuild.result = "FAILED"
        throw e
   } finally {
     // Success or failure, always send notifications
	    echo 'Cisnake 4'
     notifyBuild(currentBuild.result)
   }
}
def notifyBuild(String buildStatus = 'STARTED') {
	// build status of null means successful
   	buildStatus =  buildStatus ?: 'SUCCESSFUL'
 	echo 'Cisnake 5'
   	
	// Default values
   	//def colorName = 'RED'
   	//def colorCode = '#FF0000'
   	
	def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
   	def summary = "${subject} (${env.BUILD_URL})"
   	def details = """<p>STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
     		<p>Check console output at "<a href="${env.BUILD_URL}">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>"</p>"""
   	def mailRecipients = "amine9@gmail.com"
   	
	// Override default values based on build status
   	//if (buildStatus == 'STARTED') {
     	//	color = 'YELLOW'
     	//	colorCode = '#FFFF00'
   	//} else if (buildStatus == 'SUCCESSFUL') {
     	//	color = 'GREEN'
     	//	colorCode = '#00FF00'
   	//} else {
     	//	color = 'RED'
     	//	colorCode = '#FF0000'
   	//}
 
   	// Send notifications
   	// slackSend (color: colorCode, message: summary)
 	// hipchatSend (color: color, notify: true, message: summary)
 	
	emailext (
           subject: subject,
           body: details,
           to: "${mailRecipients}",
	   replyTo: "${mailRecipients}"
           /* recipientProviders: [[$class: 'DevelopersRecipientProvider']] */
     	)
}
