mepedia-rails
=============


Configure recover password
--------------------------
For configuring the recovering password functionality you need to specify which email will be used and it's password.
`figaro install`
his creates a commented config/application.yml file and adds it to your .gitignore. Add your own configuration to this file!
Example:
`development:
   mailer.username: mepedia@mepedia.com
   mailer.password: mepedia
`