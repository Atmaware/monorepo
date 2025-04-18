// If you use our Podcast API with Node.js or browser javascript, then use the Client class.
const { Client } = require('podcast-api');
const client = Client({
  apiKey: process.env.LISTEN_API_KEY || null,
});

// If you use our Podcast API with Cloudflare Workers / Pages, then use the ClientForWorkers class.
// Please make sure you store LISTEN_API_KEY as a secret. See example code: 
//   - https://github.com/ListenNotes/podcast-api-js/blob/main/examples/PodcastAppForWorkers/src/index.js
// const { ClientForWorkers } = require('podcast-api');
// const client = ClientForWorkers({
//  apiKey: env.LISTEN_API_KEY || null,
// });


client.search({
  q: 'elon musk',
}).then((response) => {
  console.log(response.data);
}).catch((error) => {
  if (error.response) {
    switch (error.response.status) {
      case 404:
        // Endpoint not exist or podcast / episode not exist
        break;
      case 401:
        // Wrong API key, or your account is suspended
        break;
      case 400:
        // Invalid parameters
        break;
      case 500:
        // Server-side error
        break;
      default:
        // Unknown errors
        break;
    }
  } else {
    // Failed to connect to Listen API servers
  }
  console.log(error);
});