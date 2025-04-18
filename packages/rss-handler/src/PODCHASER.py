import requests
import time
from typing import Dict, List, Optional
from bs4 import BeautifulSoup
from datetime import datetime
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class PodchaserAPI:
    """Client for interacting with Podchaser's GraphQL API."""
    
    def __init__(self, api_key: str):
        self.api_endpoint = "https://api.podchaser.com/graphql"
        self.headers = {
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        }
        self.session = requests.Session()
        self.session.headers.update(self.headers)

    def search_podcast_episodes(
        self, 
        podcast_id: str, 
        search_term: Optional[str] = None,
        fetch_transcript: bool = False
    ) -> List[Dict]:
        """
        Search for episodes in a podcast with optional search term.
        
        Args:
            podcast_id: Podchaser podcast ID
            search_term: Optional term to filter episodes
            fetch_transcript: Whether to fetch episode transcripts
            
        Returns:
            List of episode data including transcripts if requested
        """
        query = """
        query($podcastId: ID!, $searchTerm: String) {
            podcast(identifier: {id: $podcastId, type: PODCHASER}) {
                title
                description
                applePodcastsId
                spotifyId
                url
                episodes(searchTerm: $searchTerm) {
                    data {
                        url
                        title
                        airDate
                    }
                }
            }
        }
        """
        
        variables = {
            "podcastId": podcast_id,
            "searchTerm": search_term
        }
        
        try:
            response = self.session.post(
                self.api_endpoint,
                json={"query": query, "variables": variables}
            )
            response.raise_for_status()
            
            data = response.json()
            if "errors" in data:
                logger.error(f"GraphQL errors: {data['errors']}")
                return []
                
            episodes = data["data"]["podcast"]["episodes"]["data"]
            
            if fetch_transcript:
                for episode in episodes:
                    transcript = self._fetch_transcript(episode["url"])
                    episode["transcript"] = transcript
                    # Be nice to the server
                    time.sleep(1)
                    
            return episodes
            
        except requests.exceptions.RequestException as e:
            logger.error(f"Error fetching podcast episodes: {str(e)}")
            return []
            
    def _fetch_transcript(self, episode_url: str) -> Optional[str]:
        """
        Fetch transcript from episode URL by appending '/transcript'.
        
        Args:
            episode_url: URL of the podcast episode
            
        Returns:
            Transcript text if available, None otherwise
        """
        transcript_url = f"{episode_url}/transcript"
        
        try:
            response = self.session.get(transcript_url)
            response.raise_for_status()
            
            soup = BeautifulSoup(response.text, "html.parser")
            # Note: You'll need to adjust the selector based on the actual HTML structure
            transcript_element = soup.select_one("div.transcript-content")
            
            if transcript_element:
                return transcript_element.get_text(strip=True)
            return None
            
        except requests.exceptions.RequestException as e:
            logger.error(f"Error fetching transcript: {str(e)}")
            return None