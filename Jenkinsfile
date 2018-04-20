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
    */
     stage('Build Docker Image') {
         sleep(60) 
 	/*app = docker.build("${image}:${env.CHANGE_ID}:${currentBuild.displayName}")
     	app = docker.build("${image}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}")
    */
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
  	
 	
}
