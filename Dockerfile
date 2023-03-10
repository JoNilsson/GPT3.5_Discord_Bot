# Use the official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:3.10-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt file to the container
COPY requirements.txt .

# Install the required packages using pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy the bot.py and shell script to the container
COPY bot.py .
COPY run_bot.sh .

# Set the execute permission for the shell script
RUN chmod +x run_bot.sh

# Start the bot by executing the shell script
CMD ["./run_bot.sh"]