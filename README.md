# AWS Elastic Beanstalk demonstration

This repository is a demonstration of how AWS Elastic Beanstalk can be used to deploy simply highly available web sites.

It Uses the EB CLI to create an Elastic Beanstalk environment with an attached RDS DB and EFS file system to provide Drupal with a MySQL database and shared storage for uploaded files.

**NOTE**
The deployment guide assume that the Elastic BeanStalk cli is installed and configured.

## Install the application

To create the Beanstalk environment with a Drupal application, execute the following command:

    make CreateEnv env-name=yourenvname

## Configure Drupal

Configure Drupal using the web interface. In the DB section, put the information taken from RDS. (Do not forget to add the endpoint in « advanced settings »).

## Make a highly available version of Drupal

In your environment local folder, Run ` eb ssh --force` to connect to the running instance.

Copy the content of the file ` /var/app/current/sites/default/settings.php ` in your local folder `yourenvname/sites/default/settings.php` file.

**WARNING**
This is a very bad practice to store credentials in the settings files. This file shall never be inserted in a version configuration system like GitHub. This is done here only for pedagogical demonstrations. In a production environment, the settings.php file shall collect the credentials from environment variables.

In the file « .ebextensions/dev.config », Replace « "/core/install.php » by « /index.php » for the Application Healthcheck URL. 

Run the command

    eb deploy

## Change the deployment type to Immutable

In the file `.ebextensions/dev.config`, uncomment the lines `DeploymentPolicy: Immutable` and `RollingUpdateType: Immutable`.

Run the command

    eb deploy

## Scale your application to have 3 instances available

Run the command

    eb scale 3
    
This will modify the autoscaling group to have 3 running instances, 1 in each AZ.

You have successfully deploy a highly available Drupal website on Beanstalk.


## Things to demonstrate

Exemple of things to do to demonstrate beanstalk capabilities:
- Kill 2 EC2 instances and watch how the autoscaling group will recreate instances
- In your local folder, delete the index.php file and deploy the application. With the immutable deployment active, Beanstalk shall detect that the new version of the website is not running correctly and do an automatic rollback.