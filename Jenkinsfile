pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Lily-G1/cloud-resume.git'
            }
        }
        stage('Create backend state bucket') {
            steps {
                script {
                    dir('back-end/s3_bucket_state') {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                    }
                }    
            }
        }
        stage('Initialize backend') {
            steps {
                script {
                    dir('back-end') {
                        sh 'terraform init'
                    }
                }    
            }
        }
        stage('Plan backend tf') {
            steps {
                script {
                    dir('back-end') {
                        sh 'terraform plan -out tfplan'
                        sh 'terraform show -no-color tfplan > tfplan_backend.txt'
                    }
                }
            }
        }
        stage('Apply / Destroy backend') {
            steps {
                script {
                    if (params.action == 'apply') {
                        if (!params.autoApprove) {
                            def plan = readFile 'tfplan_backend.txt'
                            input message: "Do you want to apply the plan?",
                            parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                        }

                        sh 'terraform ${action} -input=false tfplan'
                    } else if (params.action == 'destroy') {
                        sh 'terraform ${action} --auto-approve'
                    } else {
                        error "Invalid action selected. Please choose either 'apply' or 'destroy'."
                    }
                }
            }
        }
        stage('Create frontend state bucket') {
            steps {
                script {
                    dir('front-end/s3_bucket_state') {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                    }
                }    
            }
        }
        stage('Initialize frontend') {
            steps {
                script {
                    dir('front-end') {
                        sh 'terraform init'
                    }
                }    
            }
        }
        stage('Plan frontend tf') {
            steps {
                script {
                    dir('front-end') {
                        sh 'terraform plan -out tfplan'
                        sh 'terraform show -no-color tfplan > tfplan_frontend.txt'
                    }
                }
            }
        }
        stage('Apply / Destroy frontend') {
            steps {
                script {
                    if (params.action == 'apply') {
                        if (!params.autoApprove) {
                            def plan2 = readFile 'tfplan_frontend.txt'
                            input message: "Do you want to apply the plan?",
                            parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                        }

                        sh 'terraform ${action} -input=false tfplan'
                    } else if (params.action == 'destroy') {
                        sh 'terraform ${action} --auto-approve'
                    } else {
                        error "Invalid action selected. Please choose either 'apply' or 'destroy'."
                    }
                }
            }
        }
    }
}