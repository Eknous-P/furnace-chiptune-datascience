# -*- coding: utf-8 -*-

import os

import google_auth_oauthlib.flow
import googleapiclient.discovery
import googleapiclient.errors

import csv

scopes = ["https://www.googleapis.com/auth/youtube.readonly"]

ASH_PLAYLIST_ID = "PLM98E7f5OROYhVKUz15lLpacLiQqmMU-v"
ASH_PLAYLIST_LEN = 4737

CREDENTIALS_FILE = "secrets/client_secret_file.json"
OUTPUT_FILE = "data.csv"
PRINT_FILE = "log.txt"

CSV_DELIM = '/'
CSV_STR_DELIM = "\""


# Disable OAuthlib's HTTPS verification when running locally.
# *DO NOT* leave this option enabled in production.
# this shall only be run locally so it can stay
os.environ["OAUTHLIB_INSECURE_TRANSPORT"] = "1"

class api:
  def __init__(self, credf):
    self.api_service_name = "youtube"
    self.api_version = "v3"
    self.client_secrets_file = credf

  def auth(self):
    self.flow = google_auth_oauthlib.flow.InstalledAppFlow.from_client_secrets_file(
      self.client_secrets_file,
      scopes
    )
    self.credentials = self.flow.run_console()
    self.youtube = googleapiclient.discovery.build(
      self.api_service_name,
      self.api_version,
      credentials=self.credentials
    )

  def requestPlaylist(self, playlist, count):
    request = self.youtube.playlistItems().list(
      part="snippet,contentDetails",
      maxResults=count,
      playlistId=playlist
    )
    response = request.execute()
    return response

  def requestVideo(self, video):
    request = self.youtube.videos().list(
      part="snippet,contentDetails,statistics",
      id=video
    )
    response = request.execute()
    return response


if __name__ == "__main__":
  yt = api(CREDENTIALS_FILE)
  yt.auth()

  playlistJson = yt.requestPlaylist(ASH_PLAYLIST_ID, ASH_PLAYLIST_LEN)
  vidIds=""
  for i in playlistJson["items"]:
    id = i["contentDetails"]["videoId"]
    # print("video id: {0}".format(id))
    vidIds+=id+','
  vidIds = vidIds.removesuffix(',')

  # print("ids {0}".format(vidIds))

  csvfile = open(OUTPUT_FILE, "w")
  data = csv.writer(csvfile, delimiter=CSV_DELIM, quotechar=CSV_STR_DELIM, quoting=csv.QUOTE_NONNUMERIC)

  logfile = open(PRINT_FILE, "w")

  data.writerow([
    "vid-id",
    "vid-auth",
    "vid-title",
    "vid-desc",
    "vid-uploaddate",
    "vid-stat_view",
    "vid-stat_like"
  ])

  vids = yt.requestVideo(vidIds)
  for i in vids["items"]:
    print("video id {0}".format(i["id"]))
    data.writerow([
      i["id"],
      i["snippet"]["channelTitle"],
      i["snippet"]["title"],
      i["snippet"]["description"],
      i["snippet"]["publishedAt"],
      i["statistics"]["viewCount"],
      i["statistics"]["likeCount"]
    ])
    print(("VIDEO DETAILS FOR {0}:\n"+
      " title: {1}\n"+
      " author: {2}\n"+
      " views: {3}\n"+
      " likes: {4}\n"+
      " uploadDate: {5}\n"
      ).format(
        i["id"],
        i["snippet"]["title"],
        i["snippet"]["channelTitle"],
        i["statistics"]["viewCount"],
        i["statistics"]["likeCount"],
        i["snippet"]["publishedAt"]
      ),file=logfile)

logfile.close()
csvfile.close()
