package app.atmaware.ruminer.core.database.entities

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity
data class NewsletterEmail(
  @PrimaryKey val newsletterEmailId: String?,
  val confirmationCode: String?,
  val email: String?
)
