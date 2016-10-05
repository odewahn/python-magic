FROM jupyter/minimal-notebook:latest

# launchbot-specific labels
LABEL name.launchbot.io="Git for DevOps"
LABEL workdir.launchbot.io="/usr/workdir"
LABEL description.launchbot.io="An introduction to git for DevOps, excerpted from Modern Linux System Administration"
LABEL 8888.port.launchbot.io="Jupyter Notebook"
LABEL 8000.port.launchbot.io="Static Site"

# Set the working directory
WORKDIR /usr/workdir

# Expose the notebook port
EXPOSE 8888
EXPOSE 8000

# Install and run the startup script
ADD run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

CMD ["/usr/local/bin/run.sh"]
