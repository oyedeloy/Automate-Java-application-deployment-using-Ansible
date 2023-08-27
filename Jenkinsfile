pipeline {
    agent any
    stages {
        stage ('build_clean_test_app'){
            steps {
            
               sh "mvn compile"
               sh "mvn test"
               sh "mvn pmd:pmd"
               sh "mvn package"  
            }                   
            
        

        
        }
        
        stage('apply') {
           environment {
            AWS_ACCESS_KEY_ID = credentials('ACCESS_KEY')
            AWS_SECRET_ACCESS_KEY = credentials('SECRET_KEY')
           }
        
            steps {
                step {
                 sh 'terraform init'
                 sh 'terraform apply -auto-approve'
                }
            }
        }
        
    }    
}
