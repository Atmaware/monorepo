package app.atmaware.ruminer.core.network

import app.atmaware.ruminer.core.datastore.DatastoreRepository
import app.atmaware.ruminer.core.datastore.ruminerAuthToken
import app.atmaware.ruminer.core.datastore.ruminerSelfHostedApiServer
import app.atmaware.ruminer.utils.Constants
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
