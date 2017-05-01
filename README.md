Messenger app
================
[Try out demo on Heroku](https://poustovit-messenger.herokuapp.com/)

Simple application where users can send messages to each other.

## Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Build With
* Ruby 2.3.4
* Rails 5.0.2
* Rspec 3.5.0
* Bootstrap 3
* Deployed on Heroku
* Continuous Integration with CircleCI

### Installing
A step by step series of examples that tell you have to get a development env running

Clone project:
```
$ git clone https://github.com/poustovitss/simple_messenger.git
```

Rename database.yml.example to database.yml:
```
$ mv database.yml.example database.yml
```

Set `username` and `password` values right for your db settings in database.yml file.

Setup db:
```
rails db:create && rake db:migrate && rake db:seed
```

Run server:
```
rails s
```
### Running the tests
You can run tests with:
```
rspec
```
### Deployment
Deployed version: [https://poustovit-messenger.herokuapp.com/](https://poustovit-messenger.herokuapp.com/)