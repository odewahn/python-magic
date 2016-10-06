FROM jupyter/scipy-notebook:latest

# launchbot-specific labels
LABEL name.launchbot.io="Object Oriented Python"
LABEL workdir.launchbot.io="/usr/workdir"
LABEL description.launchbot.io="Object-oriented Python."
LABEL 8888.port.launchbot.io="Jupyter Notebook"
LABEL 8000.port.launchbot.io="Oriole"
LABEL 8080.port.launchbot.io="Edit cues points"

# Set the working directory
WORKDIR /usr/workdir

# Expose the notebook port
EXPOSE 8888
EXPOSE 8000
EXPOSE 8080

# Install and run the startup script
USER root
ADD run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh
USER jovyan 

CMD ["/usr/local/bin/run.sh"]
