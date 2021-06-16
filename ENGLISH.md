# kontes-terbuka: Indonesian Online Math Contest website
![Indonesian Online Math Contest Logo](https://github.com/donjar/kontes-terbuka/raw/production/app/assets/images/logo-hires.png)
[Klik di sini untuk versi Bahasa Indonesia.](README.md)
[![Build Status](https://travis-ci.org/donjar/kontes-terbuka.svg?branch=production)](https://travis-ci.org/donjar/kontes-terbuka)
[![Coverage Status](https://coveralls.io/repos/github/donjar/kontes-terbuka/badge.svg?branch=production)](https://coveralls.io/github/donjar/kontes-terbuka?branch=production)

This repository contains code for Indonesian Online Math Contest's website
which can be accessed in https://ktom.tomi.or.id. This website is made by
two members of our organization:
- Herbert Ilhan Tanujaya (@donjar)
- Jonathan Mulyawan Woenardi (@woenardi)

This website was originally made to learn web development in Ruby on Rails.
However, the source code keeps on expanding as we add on more features.

## Initial Setup
Note: the following set-up procedure runs on Ubuntu 20.04 LTS. These steps are
recommended although need not be followed exactly. If you wish to run
Ubuntu on another OS, you may want to consider
[VirtualBox](https://www.virtualbox.org/wiki/Downloads) to run Ubuntu in a
virtual machine. 

### Prerequisite packages
For the project to run on your machine, you would need to install several packages:
1. `software-properties-common`, as a dependency for several packages below
2. `postgresql` for the database
3. `texlive` for LaTeX parsing. `texlive-full` is recommended, although `texlive-base` would suffice for most parts

You can use `apt` for installing the above packages by the command
```bash
sudo apt install <packagename>
```

### Setup steps
1. Install the prerequisite packages
2. Download the files in the repository, through `git clone` or otherwise   
3. We would also need `ruby`, and for the purposes of version management we would like to recommend using `rvm` or `rbenv`.
   This step shows how to set up `rvm` and may be skipped if you prefer other ways of version management. 
   This step will follow closely with the official Ubuntu installation guide [here](https://github.com/rvm/ubuntu_rvm), 
   and modified slightly to suit the project:
    1. Add the PPA and install the required packages:
       ```bash
       sudo apt-add-repository -y ppa:rael-gc/rvm
       sudo apt-get update
       sudo apt-get install rvm
       ```
    2. Add your user to the rvm group (replace `<yourusername>` by your username):
        ```bash
        sudo usermod -a -G rvm <yourusername>
        ```
    3. Change your terminal to run command as login shell. This can be done manually through `/bin/bash --login`;
       if you are using the default GNOME terminal you can configure it by clicking on the hamburger button 
       (three horizontal lines) on the top right corner of the terminal window and selecting Preferences. In the
       preferences window under your Profile on the left sidebar, select your profile, and click on the Command tab. Check the
       'Run command as login shell' checkbox
    4. Reboot
    5. Enable local gemsets by using
        ```bash
        rvm user gemsets
        ```
    6. Now you can install `ruby`. This project currently uses ruby 2.5.0 
       (check the Gemfile in the project folder root if you are unsure, it should be in one of the first few lines), 
       so we will install that version of ruby by using the command
        ```bash
        rvm install 2.5.0
        ```
       If you have installed other version(s) of ruby, you can change the default ruby version
       by using the command 
        ```bash
        rvm --default use 2.5.0
        ```
       and this would require closing and reopening your terminal to take effect
4. Check that you have the correct version of ruby (currently 2.5.0, check against the Gemfile). This can be done by running
    ```bash
    ruby --version
    ```
5. Install `bundler` on the correct version. Currently, bundler 1.17.3 is recommended for the project.
   For more details on the bundler version, refer to the Gemfile.lock file.
    ```bash
    gem install bundler -v 1.17.3
    ```
6. From the directory of the project, run
    ```bash
    bundle install
    ```
   to install the gems needed
7. Make sure that `postgresql` is installed. Now we move to creating our database: 
    1. Make a file called `database.yml` in the `config` folder. 
       You can do this by copying the given `database.yml.default` file in the project
    2. We will make a user in postgresql. For the purposes of this guide, we will make
       a user with username `ubuntu` and password `password`. Please ensure that the username
       and the password in the following steps match the ones in your `database.yml`:  
        1. Go to postgres shell: `sudo -u postgres psql`
        2. Create the user: `create user ubuntu with encrypted password 'password';`
        3. Elevate user privilege: `alter user "ubuntu" with superuser;`
    3. Now we will set the database up with `bundle exec rake db:setup`
    4. Run all migration files by `bundle exec rake db:migrate`
8. Create `.env` file in the root directory and copy over the contents from `.env.default` to `.env`. Populate the variables inside `.env` with the appropriate values.
9. The initial setup to run the server has been done. To run the local server, use
    ```bash
    bundle exec rails s
    ```
10. Last, you may wish to make an admin in the website (by default would be on `0.0.0.0:3000`). 
   Do the following steps to make an admin account in the website:
    1. Make a user as per normal in the website
    2. No email will be sent, instead we need to go to rails console and manually enable the user. 
        Open the rails console by `bundle exec rails c` and run `User.first.enable`
    3. To elevate the privilege of this user to admin, do the following in the rails console:
    ```bash
    User.first.add_role :panitia
    User.first.add_role :admin 
    ```

This completes the initial set up guide for the website.


## Contribute
Please fork :D
