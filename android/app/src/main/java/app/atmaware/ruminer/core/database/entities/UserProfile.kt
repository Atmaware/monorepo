package app.atmaware.ruminer.core.database.entities

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity
data class UserProfile(
  @PrimaryKey val userID: String,
  val name: String?,
  val username: String?,
  val profileImageURL: String?,
)

