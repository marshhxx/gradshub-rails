gradshub-rails
=============


Configure recover password
--------------------------
For configuring the recovering password functionality you need to specify which email will be used and it's password.
```
figaro install
````

This creates a commented config/application.yml file and adds it to your .gitignore. Add your own configuration to this file!
Example:

```
development:
   mailer.username: noreply@gradshub.com
   mailer.password: *****
   host: localhost:3000
```