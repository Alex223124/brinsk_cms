[![CircleCI](https://circleci.com/gh/bdfinlayson/brinsk_cms/tree/master.svg?style=svg)](https://circleci.com/gh/bdfinlayson/brinsk_cms/tree/master)

Brinsk is a contact management system written in Ruby and Rails as my final capstone project at Nashville Software School. It's features include:

- Full text search
- Google Maps and geolocation
- Gravatar
- Calendar management
- Email via ActiveMailer
- Task management
- Project management
- Notes (for contacts and projects)

and much more...

Built using the Bourbon and Neat CSS frameworks. 

To install, clone the repo, run `bundle install` followed by `rake db:migrate` then enjoy by running it on localhost!

You can also [test-drive the app live on Heroku](https://brinsk.herokuapp.com/users/sign_in). Sign in with the demo account credentials:

- Username: demo@demo.com
- Password: demo1234

This is the initial ERM (entity relationship model) that I created during the initial planning process. It proved invaluable as a roadmap during the app's development:

<img src=capstone_erm_v2.jpg>
