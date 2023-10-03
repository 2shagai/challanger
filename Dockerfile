# Use the official Ubuntu 20.04 image as the base image
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && apt-get install -y vsftpd openssh-server shc gcc vim

# Create user "red_user" with a home directory
RUN useradd -m red_user
# Set the password for "red_user" to "cheese"
RUN echo 'red_user:cheese' | chpasswd

# Create a user "ftp_checker" without a home directory
RUN useradd -r ftp_checker

# Install any additional tools or packages specific to the red_user challenge

# Install vsftpd and configure it for anonymous access
RUN apt-get install -y vsftpd
RUN sed -i 's/anonymous_enable=NO/anonymous_enable=YES/' /etc/vsftpd.conf
RUN sed -i 's/#anon_upload_enable=YES/anon_upload_enable=NO/' /etc/vsftpd.conf
RUN sed -i 's/#anon_mkdir_write_enable=YES/anon_mkdir_write_enable=NO/' /etc/vsftpd.conf

# Create a directory for anonymous FTP uploads if it doesn't exist
RUN mkdir -p /srv/ftp && chown nobody:nogroup /srv/ftp

# Configure vsftpd to allow read-only access
RUN echo "local_enable=YES" >> /etc/vsftpd.conf
RUN echo "write_enable=NO" >> /etc/vsftpd.conf

# Copy red_user-specific challenge files or scripts into the Docker image
#COPY red_challenge_files /challenge

# Copy the FTP checker script to the /challenge directory

COPY Readme_red.txt /srv/ftp/Readme_red.txt
COPY flag2_red.txt /home/red_user/flag2_red.txt
RUN chmod 444 /srv/ftp/Readme_red.txt


COPY check.sh  /challenge/
RUN chown red_user:red_user /challenge/check.sh  # Change ownership to red_user
RUN shc -f /challenge/check.sh -o /challenge/check.x
RUN rm /challenge/check.sh
RUN rm /challenge/check.sh.x.c
 
# Create a group for red_user and add red_user to it
RUN groupadd red_group
RUN usermod -a -G red_group red_user

# Set the group ownership of check.sh to red_group
RUN chown :red_group /challenge/check.x

# Set the setgid permission on check.sh to prevent others from reading
RUN chmod 550 /challenge/check.x

# Start SSH server
RUN service ssh start

# Expose FTP and SSH ports
EXPOSE 21 22

# Set up a script or entry point to start the red_user challenge
ENTRYPOINT ["sleep"]
CMD ["84600"]
