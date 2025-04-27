# -*- coding: utf-8 -*-

import os

import google_auth_oauthlib.flow
import googleapiclient.discovery
import googleapiclient.errors

scopes = ["https://www.googleapis.com/auth/youtube.readonly"]

CREDENTIALS_FILE = "secrets/client_secret_file.json"

def request(playlist, count):
  # Disable OAuthlib's HTTPS verification when running locally.
  # *DO NOT* leave this option enabled in production.
  # this shall only be run locally so it can stay
  os.environ["OAUTHLIB_INSECURE_TRANSPORT"] = "1"

  api_service_name = "youtube"
  api_version = "v3"
  client_secrets_file = CREDENTIALS_FILE

  # Get credentials and create an API client
  flow = google_auth_oauthlib.flow.InstalledAppFlow.from_client_secrets_file(
    client_secrets_file, scopes)
  credentials = flow.run_console()
  youtube = googleapiclient.discovery.build(
    api_service_name, api_version, credentials=credentials)

  request = youtube.playlistItems().list(
    part="snippet,contentDetails",
    maxResults=count,
    playlistId=playlist
  )
  response = request.execute()

  return response

if __name__ == "__main__":
  request("PLM98E7f5OROYhVKUz15lLpacLiQqmMU-v", 5)
  
    # "PLM98E7f5OROYhVKUz15lLpacLiQqmMU-v"