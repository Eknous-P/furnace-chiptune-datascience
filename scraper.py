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

  def requestPlaylist(self, playlist, count, page):
    if (len(page)>0):
      request = self.youtube.playlistItems().list(
        part="snippet,contentDetails",
        maxResults=count,
        playlistId=playlist,
        pageToken=page
      )
    else:
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
  nextPage=""
  fetchCount=0

  csvfile = open(OUTPUT_FILE, "w")
  data = csv.writer(csvfile, delimiter=CSV_DELIM, quotechar=CSV_STR_DELIM, quoting=csv.QUOTE_NONNUMERIC)

  logfile = open(PRINT_FILE, "w")

  data.writerow([
    "vid-id",
    "vid-auth",
    "vid-title",
    "vid-desc",
    "vid-uploaddate",
    "vid-stat-view",
    "vid-stat-like"
  ])

  while (fetchCount<ASH_PLAYLIST_LEN):
    playlistJson = yt.requestPlaylist(ASH_PLAYLIST_ID, ASH_PLAYLIST_LEN, nextPage)
    vidIds=""
    fetchCount += len(playlistJson["items"])
    try:
      nextPage = playlistJson["nextPageToken"]
    except KeyError:
      nextPage = ""
    for i in playlistJson["items"]:
      id = i["contentDetails"]["videoId"]
      # print("video id: {0}".format(id))
      vidIds+=id+','
    vidIds = vidIds.removesuffix(',')

    # print("ids {0}".format(vidIds))
    v_id=""
    v_chan_title=""
    v_title=""
    v_desc=""
    v_upload=""
    v_views=""
    v_likes=""

    vids = yt.requestVideo(vidIds)
    for i in vids["items"]:
      try:
        v_id         = i["id"]
        v_chan_title = i["snippet"]["channelTitle"]
        v_title      = i["snippet"]["title"]
        v_desc       = i["snippet"]["description"]
        v_upload     = i["snippet"]["publishedAt"]
        v_views      = i["statistics"]["viewCount"]
        v_likes      = i["statistics"]["likeCount"]
      except KeyError:
        print("weird keyerror")
      print("writing csv of video id {0}".format(v_id))
      data.writerow([
        v_id,
        v_chan_title,
        v_title,
        v_desc,
        v_upload,
        v_views,
        v_likes
      ])
      print(("VIDEO DETAILS FOR {0}:\n"+
        " title: {1}\n"+
        " author: {2}\n"+
        " views: {3}\n"+
        " likes: {4}\n"+
        " uploadDate: {5}\n"
        ).format(
          v_id,
          v_title,
          v_chan_title,
          v_views,
          v_likes,
          v_upload
        ),file=logfile)

logfile.close()
csvfile.close()
