# big-bank-cfi-suite-sw-testing-team-9
big-bank-cfi-suite-sw-testing-team-9 created by GitHub Classroom

## Execution instructions:
### Docker:
__After compiling the project__, run the following: 

* run the following to build and test production code in a Docker container:
    ```shell script
    docker build -f Dockerfile.production -t production:latest . && docker run production:latest 
    ```

* run the following to build and test unit tests in a Docker container
    ```shell script
    docker build -f Dockerfile.test -t test:latest . && docker run test:latest 
    ```
  
### Vagrant:  
#### Setting up Vagrant 
Download and install our repository. The Vagrantfile includes commands for setting up the 
virtual machine and installing Java JDK8.
#### Commands
##### Vagrant init
Initializes Vagrant
##### Vagrant up
Starts the virtual machine and runs the vagrantfile
##### Vagrant ssh 
Use to log into your vitual machine.

##### Running Tests
All of the tests will be included in a tests folder. Navigate to the test folder and compile the test file you wish to run using javac, then run that test file using the java command. 


