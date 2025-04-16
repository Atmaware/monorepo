package app.atmaware.ruminer.core.network

import app.atmaware.ruminer.graphql.generated.ViewerQuery
import app.atmaware.ruminer.core.database.entities.Viewer

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
