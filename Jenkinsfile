node('jenkins-slave') {

    def mvnHome = tool 'maven3'
    def kaka
    /* def VERSION=$(date %Ym%d%H%M%S).git.$GIT_REVISION */
    def image = "total/atlas-app"
    /* :${env.BRANCH_NAME}.${env.BUILD_NUMBER}" */
    
    stage('Checkout') {
        def toto = checkout scm
        def titi = toto.GIT_COMMIT
        kaka = toto
    }
    
   /* stage('Send email') {
    *    def mailRecipients = "amine9@gmail.com"
    *    def jobName = currentBuild.fullDisplayName

    *    emailext body: '''${SCRIPT, template="groovy-html.template"}''',
    *    mimeType: 'text/html',
    *    subject: "[Jenkins] ${jobName} ${env.CHANGE_ID}",
    *    to: "${mailRecipients}",
    *    replyTo: "${mailRecipients}"
    *    * recipientProviders: [[$class: 'CulpritsRecipientProvider']] *
    *}
    *
    * stage('Build Docker Image') {
    *    sleep(60)
 	*	app = docker.build("${image}:${env.CHANGE_ID}:${currentBuild.displayName}")
    * 	app = docker.build("${image}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}")
    * }
    */ 
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
  	
  	/* stage('deploy') {
     *	sh "${mvnHome}/bin/mvn deploy"
     * }
     */
  	
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
    
 	/* stage('Push image In Public Repository') {
	 *	* Finally, we'll push the image with two tags:
     *    * First, the incremental build number from Jenkins
     *    * Second, the 'latest' tag.
     *    * Pushing multiple tags is cheap, as all the layers are reused.
     *   
     *   docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
     *       app.push("latest")
     *       app.push("${env.BUILD_NUMBER}")
     *       
     *   }
     *} 
  	 */
  	 
  	stage('deploy APP') {
  	    sh("kubectl apply -f atlas_app_deploy.yaml")
  	    sh("kubectl apply -f atlas_app_service.yaml")
  	    sh("kubectl apply -f atlas_app_ingress.yaml")
  	}
  	post {
        always {
            echo 'One way or another, I have finished'
           /*  deleteDir()  clean up our workspace */
        }
        success {
            echo 'I succeeeded!'
        }
        unstable {
            echo 'I am unstable :/'
        }
        failure {
            echo 'I failed :('
        }
        changed {
            echo 'Things were different before...'
        }
    }
  	
  	
    
    
    /* stage ('Run') {
     *      docker.image("total/myapp").run('--rm -p 18090:8090 -p 18091:8091 --name app')
     * } */
 
    /*  stage ('Final') {
     *     build job: 'customer-service-pipeline', wait: false
     * }*/ 
  	
}

    

