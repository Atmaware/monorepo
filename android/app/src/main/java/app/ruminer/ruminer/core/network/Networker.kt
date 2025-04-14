package app.ruminer.ruminer.core.network

import app.ruminer.ruminer.core.datastore.DatastoreRepository
import app.ruminer.ruminer.core.datastore.ruminerAuthToken
import app.ruminer.ruminer.core.datastore.ruminerSelfHostedApiServer
import app.ruminer.ruminer.utils.Constants
import com.apollographql.apollo3.ApolloClient
import javax.inject.Inject

class Networker @Inject constructor(
    private val datastoreRepo: DatastoreRepository
) {
    suspend fun baseUrl() =
        datastoreRepo.getString(ruminerSelfHostedApiServer) ?: Constants.apiURL

    private suspend fun serverUrl() = "${baseUrl()}/api/graphql"
    private suspend fun authToken() = datastoreRepo.getString(ruminerAuthToken) ?: ""

    suspend fun authenticatedApolloClient() = ApolloClient.Builder().serverUrl(serverUrl())
        .addHttpHeader("Authorization", value = authToken())
        .addHttpHeader("X-RuminerClient", value = "android")
        .build()
}
