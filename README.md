# README

## Requirement

  - `Ruby` version >= **2.5.0**
  - **[Cloudinary](https://cloudinary.com/)** Account (for env_production)

## Installation

```
  # $ cd project_directory
  $ git clone --depth 1 https://github.com/hogemax/Simple-SNS.git example_test_name
  $ bundle install --path vendor/bundle
  $ bundle exec rails db:migrate

  # if your Rails version < 5.0
  # $ bundle exec rake db:migrate
```

### For need item to edit
  direnv

```
$ brew install direnv

 or

$ git clone http://github.com/zimbatm/direnv
$ cd direnv
$ sudo make install
```

### input your Cloudinary YML data
```
$ direnv edit .

#Setting for cloudinary
export CLOUDINARY_CLOUD_NAME="xxxxxxxx"
export CLOUDINARY_API_KEY="xxxxxxxxxxxxx"
export CLOUDINARY_API_SECRET="xxxxxxxxxxxxx"
```

### Try on local server
```
$ bundle exec rails s
```

# In the case of Heroku

## Environment variable

- CLOUDINARY_CLOUD_NAME
- CLOUDINARY_API_KEY
- CLOUDINARY_API_SECRET

```
# Example
$ heroku config:set CLOUDINARY_CLOUD_NAME=xxxxxxxx
```
