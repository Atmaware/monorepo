package app.ruminer.ruminer.core.network

import app.ruminer.ruminer.graphql.generated.ViewerQuery
import app.ruminer.ruminer.core.database.entities.Viewer

suspend fun Networker.viewer(): Viewer? {
  try {
    val result = authenticatedApolloClient().query(ViewerQuery()).execute()
    val me = result.data?.me

    return if (me != null) {
      Viewer(
        userID = me.id,
        name = me.name,
        username = me.profile.username,
        profileImageURL = me.profile.pictureUrl,
        intercomHash = me.intercomHash,
      )
    } else {
      null
    }
  } catch (e: java.lang.Exception) {
    return null
  }
}
